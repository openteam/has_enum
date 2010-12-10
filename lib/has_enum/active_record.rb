module HasEnum
  module ActiveRecord
    def self.included(base)
      base.write_inheritable_hash(:enum, {})
      base.extend(ClassMethods)
    end

    module ClassMethods
      def enum(attribute = nil)
        @enum ||= read_inheritable_attribute(:enum)
        attribute ? @enum[attribute.to_sym] : @enum
      end

      def has_enum(attribute, values, options = {})
        enum[attribute] = values.freeze

        if options[:query_methods] != false
          values.each do |val|
            define_method(:"#{val}?") { self.send(attribute) == val }
          end
        end

        define_method(:"#{attribute}=") do |value|
          if value.nil? or values.find{ |val| val == value }
            set_value  = lambda { |value| value.is_a?(Symbol) ? Marshal.dump(value) : value }
            self[:"#{attribute}"] = value.nil? ? nil : set_value.call(value)
          else
            errors.add(:"#{attribute}", "#{value} is not in enum")
          end
        end

        define_method(:"#{attribute}") do
          load_value = lambda { |value| value[0].getbyte(0) == 4 ? Marshal.load(value) : value }
          value = self[:"#{attribute}"]
          value ? load_value.call(value) : nil
        end

        define_method "human_#{attribute}" do
          begin
            return nil unless self.send(attribute)
            key = "activerecord.attributes.#{self.class.name.underscore}.#{attribute}_enum.#{self.send(attribute)}"
            translation = I18n.translate(key, :raise => true)
          rescue I18n::MissingTranslationData
            self.send(attribute).humanize
          end
        end
      end

      def values_for_select_tag(enum)
        values = enum(enum)
        begin
          translation = I18n.translate("activerecord.attributes.#{self.name.underscore}.#{enum}_enum", :raise => true)
          values.map { |value| [translation[value.to_sym], value] }
        rescue I18n::MissingTranslationData
          values.map { |value| [value.humanize, value] }
        end
      end
    end
  end
end