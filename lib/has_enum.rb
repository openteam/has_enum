module HasEnum

  autoload :ClassMethods,            'has_enum/class_methods'

  def self.included(base)
    base.class_attribute :enums
    base.enums ||= HashWithIndifferentAccess.new

    base.extend ClassMethods
  end

end

require 'active_record'

class ActiveRecord::Base
  include HasEnum
end

begin
  require 'formtastic'
  require 'has_enum/formtastic'
rescue LoadError
end
