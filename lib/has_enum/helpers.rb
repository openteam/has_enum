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
    values_for_enum_tag.map do |val|
      radio_button = to_radio_button_tag(val.last, options)
      [ radio_button, to_label_tag(val.first, :for => radio_button.match(/ id="(.*?)"/)[1]) ] * $/
    end.join($/)
  end

  def to_select_enum_tag(options = {})
    html_options = options.delete(:html) || {}
    to_select_tag(values_for_enum_tag, options, html_options)
  end

  def values_for_enum_tag
    values = object.class.enum(method_name.to_sym)
    begin
      translation = I18n.translate("activerecord.attributes.#{object.class.name.i18nize}.#{method_name}_enum", :raise => true)
      values.map { |val| [translation[val.to_sym], val] }
    rescue I18n::MissingTranslationData
      values.map { |val| [val.humanize, val] }
    end
  end
end


class ActionView::Helpers::FormBuilder

  def radio_button_enum(method, options = {})
    @template.radio_button_enum(@object_name, method, objectify_options(options))
  end

  def select_enum(method, options = {})
    @template.select_enum(@object_name, method, objectify_options(options.merge(:include_blank => true)))
  end
end