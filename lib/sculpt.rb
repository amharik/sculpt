require 'active_record'
require 'active_support'

require 'sculpt/version'
require 'sculpt/sculptor'
require 'sculpt/sculptor_methods'
require 'sculpt/sculpt_proxy_builder'


module Sculpt
  class Sculpt
    include Sculptor

  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.class_eval do
    include Sculpt::SculptorMethods
  end
end
