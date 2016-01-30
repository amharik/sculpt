module SculptProxyBuilder
  extend self

  def build klass, options={}
    whitelisted_methods = options[:members] || []
    module_methods = options[:methods] || []
    include_modules = options[:include_modules] || []
    obj_proxy  = Struct.new("#{klass}SculptProxy", *whitelisted_methods) do
      @module_methods = module_methods

      def self.module_methods
        @module_methods
      end

      if include_modules.present?
        class_eval do
          include_modules.each{|m| include m}
        end
      end

      def to_h
        h = Hash[self.each_pair.to_a]
        puts "#{self.class.module_methods.inspect}"
        puts self.inspect
        puts self.class.inspect
        self.class.module_methods.each do |m|
          h[m] = self.respond_to?(m)? self.send(m) : nil
        end
        h
      end

      def raw=(o)
        @target = o
      end
    end
    obj_proxy
  end

end

