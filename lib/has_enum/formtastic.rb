begin
  require 'formtastic'

  Formtastic::SemanticFormBuilder.class_eval do

    def enum_input(method, options = {})
      options.merge! :collection => object.class.values_for_select_tag(method),
                     :wrapper_html => {:class => :enum}
      self.select_input(method, options)
    end

    def default_input_type_with_enum(method, options={})
      if object.class.respond_to?(:enums) && object.class.has_enum?(method)
        :enum
      else
        default_input_type_without_enum(method, options)
      end
    end

    alias_method_chain :default_input_type, :enum

  end
rescue LoadError
end
