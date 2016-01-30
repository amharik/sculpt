#  sculptor
#    /ˈskʌlptə/
#    (noun) an artist who makes sculptures.
#
#

module Sculptor

  def self.included(base)
    base.class_eval{ extend ClassMethods }
  end

  module ClassMethods

    def start_to_sculpt template_file_path=nil
      puts "** inting sculpt #{template_file_path}**"
      template = {}
      if template_file_path.present?
        template = File.exists?(template_file_path) ?  YAML::load_file(template_file_path).with_indifferent_access : {}
        puts "** template is #{template}**"
        template.each{|model, methods| sculpt_for model, methods}
      end
    end

    def sculpt_config
      @sculpt_config ||= {}
      if block_given?
        @sculpt_config.merge!(yield)
      else
        @sculpt_config
      end
    end

    def sculpt model, options={}
      yield if block_given?
      self.attribute.push(options) if options.present?
      sculpt_for model, self.attribute
    end

    def attribute *attrs
      @attribute ||= []
      if attrs.present?
        @attribute = attrs
      end
      puts "~~~  Setting attrs as #{@attribute}"
      @attribute
    end

    alias_method :attributes, :attribute

    def node attr_name=nil, &blk
      if attr_name.present?
        @node ||= {}
        @attribute << attr_name
        @node[attr_name.to_sym] = blk
        puts "~~~  Setting node as #{@node}"
      else
        @node || {}
      end
    end

    def sculpt_attrs_for obj
      klass = obj.class
      puts "*** #{instance_var_name} [#{obj.class}]***"
      sculpt_defn = klass.read_inheritable_attribute(instance_var_name) || {}
      wrap_type = sculpt_defn[:template]
      methods = sculpt_defn[:methods]
      #wrap_type = defn[klass.to_s.underscore] || defn[klass.superclass.to_s.underscore]
      return nil if wrap_type.nil?

      fields  = wrap_type.members.map do |x|
        x=x.to_sym
        v = nil
        if self.node.has_key? x
          v = obj.instance_eval(&node[x])
        elsif obj.respond_to? x
            v = obj.send(x)
            v = case v
                when Array, ActiveRecord::Associations::AssociationCollection  then
                  v.map{|x| sculpt_attrs_for(x)}
                when ActiveRecord::Associations::AssociationProxy  then
                  sculpt_attrs_for(v)
                when Hash then
                  Hash[v.map{|k,val| [k,sculpt_attrs_for(val)] }]
                when Money then
                  v.to_s
                when String, Fixnum, Time, Date, TrueClass, FalseClass, DateTime, Symbol then
                  v
                else
                  # has_one/ belongs_to relation
                  if (apple = sculpt_attrs_for(v)).present?
                    apple
                  else
                    puts "Type '#{v.class}' unknown: #{v}"
                    nil
                  end
                end
        else
          puts "Method '#{x}'  not found on object '#{obj}'"
        end
      end
      ret = wrap_type.new(*fields)
      ret.raw = obj
      ret
    end

    private

      def instance_var_name
        "sculpt_for_#{tag}"
      end

      def tag
        @tag ||= sculpt_config[:tag] || begin
        klass_name = self.to_s.underscore
        if klass_name == 'sculpt'
          'base'
        else
          klass_name.gsub(/_sculpt/, '')
        end
        end
      end

      def sculpt_for model, methods
        klass = model.to_s.classify.constantize
        whitelisted_methods = []
        include_modules = []
        module_methods = []
        methods.each do |m|
          if m.is_a?(Hash)
            if m[:include].present?
              include_module = m[:include]
              include_modules << include_module
              module_methods << include_module.instance_methods.map(&:to_sym)
            else
              # handle annonymous
              # handle alias case
            end
          else
            whitelisted_methods << m
          end
        end
        module_methods.flatten!
        puts "*** Modules #{include_modules.inspect} Module methods '#{module_methods.inspect}' Whitelist '#{whitelisted_methods.inspect}'***"
        obj_proxy  = SculptProxyBuilder.build klass, :members => whitelisted_methods, :methods => module_methods, :modules => include_modules
        klass.write_inheritable_attribute(instance_var_name,{
          :template => obj_proxy,
          :node => self.node,
          :methods =>  module_methods
        })
      end

  end

end

