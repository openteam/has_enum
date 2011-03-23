module HasEnum

  autoload :ClassMethods,            'has_enum/class_methods'

  def self.included(base)
    base.write_inheritable_hash(:enum, {}.with_indifferent_access)
    base.extend ClassMethods
  end

end

class ActiveRecord::Base
  include HasEnum
end

