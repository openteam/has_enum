module ActionView::Helpers::FormHelper
  def radio_button_enum(object_name, method, options = {})
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).
      to_radio_button_enum_tag(options)
  end

  def select_enum(object_name, method, options = {})
    ActionView::Helpers::InstanceTag.new(object_name, method, self, options.delete(:object)).
      to_select_enum_tag(options)
  end
end


class ActionView::Helpers::InstanceTag
  def to_radio_button_enum_tag(options = {})
    values_for_enum_tag.map do |val|
      radio_button = to_radio_button_tag(val.last, options)
      [radio_button, to_label_tag(val.first, :for => radio_button.match(/ id="(.*?)"/)[1])] * $/
    end.join($/)
  end

  def to_select_enum_tag(options = {})
    html_options = options.delete(:html) || {}
    to_select_tag(values_for_enum_tag, options, html_options)
  end

  def values_for_enum_tag
    object.class.human_enums[method_name].invert.to_a
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
      if @object.class.respond_to?(:enum) && @object.class.enums[method] && !options[:as]
        enum_input(method, options)
      else
        input_without_enum(method, options)
      end
    end

    alias_method_chain :input, :enum

  end
rescue LoadError
end
