Formtastic::SemanticFormBuilder.class_eval do

  def enum_input(method, options = {})
    options.merge! :collection => object.class.values_for_select_tag(method)
    if object.class.has_mutliple_enum? method
      check_boxes_input method, options
    else
      select_input method, options.merge(:wrapper_html => {:class => :enum})
    end
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

