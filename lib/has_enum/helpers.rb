module ActionView::Helpers::FormHelper

  def radio_button_enum(object_name, method, options = {})
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_radio_button_enum_tag(options)
  end        

  def select_enum(object_name, method, options = {})
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).to_select_enum_tag(options)
  end
end
    
class ActionView::Helpers::InstanceTag

  def to_radio_button_enum_tag(options = {})
    values = options.delete(:values) || object.class.enum(method_name.to_sym)
    values = values.map do |val|
      radio_button = to_radio_button_tag(val, options)
      [ radio_button, to_label_tag(object.class.human_attribute_name(val), :for => radio_button.match(/ id="(.*?)"/)[1]) ]
    end
    values.flatten.join($/)
  end

  def to_select_enum_tag(options = {})
    values = options.delete(:values) || object.class.enum(method_name.to_sym)
    html_options = options.delete(:html) || {}
    to_select_tag(values.map{ |val| [object.class.human_attribute_name(val), val] }, options, html_options)
  end
end

class ActionView::Helpers::FormBuilder

  def radio_button_enum(method, options = {})
    @template.radio_button_enum(@object_name, method, objectify_options(options))
  end        

  def select_enum(method, options = {})
    @template.select_enum(@object_name, method, objectify_options(options))
  end        
end
