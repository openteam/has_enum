module HasEnum

  autoload :ClassMethods,            'has_enum/class_methods'

  def self.included(base)
    base.write_inheritable_attribute(:enums, HashWithIndifferentAccess.new)
    base.extend ClassMethods
  end

end

class ActiveRecord::Base
  include HasEnum
end

