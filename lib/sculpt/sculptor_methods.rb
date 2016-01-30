module Sculpt
  module SculptorMethods

    def sculpt tag='base'
      klass = tag == 'base'? Sculpt : "#{tag}_sculpt".classify.constantize
      @sculpted_attrs ||= klass.sculpt_attrs_for self
    end

  end
end

