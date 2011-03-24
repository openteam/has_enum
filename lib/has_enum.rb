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

begin
  require 'formtastic'

  Formtastic::SemanticFormBuilder.class_eval do

    def enum_input(method, options = {})
      value = @object.send(method)
      options.reverse_merge! :as => :select,
                             :collection => @object.class.human_enums[method].invert.to_a
      self.input(method, options).gsub(/class="select/, 'class="enum')
    end

    def input_with_enum(method, options={})
      if @object.class.respond_to?(:enums) && @object.class.enums[method] && !options[:as]
        enum_input(method, options)
      else
        input_without_enum(method, options)
      end
    end

    alias_method_chain :input, :enum

  end
rescue LoadError
end
