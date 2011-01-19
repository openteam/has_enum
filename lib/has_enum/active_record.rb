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

      def human_enum(attribute = nil)
        if attribute.nil?
          hash = {}
          enum.each_pair do |attribute, values|
            begin
              hash[attribute] = I18n.t("activerecord.attributes.#{self.klass_key}.#{attribute}_enum", :raise => true).values
            rescue I18n::MissingTranslationData
              hash[attribute] = values.map { |value| value.to_s.humanize }
            end
          end
          hash
        else
          begin
            I18n.t("activerecord.attributes.#{self.klass_key}.#{attribute}_enum", :raise => true).values
          rescue I18n::MissingTranslationData
            enum[attribute].map { |value| value.to_s.humanize }
          end
        end
      end

      def has_enum(attribute, values, options = {})
        options.assert_valid_keys(:query_methods, :scopes)
        enum[attribute] = values.freeze

        values.each do |val|
          scope :"#{attribute}_#{val}", where(:"#{attribute}" => "#{val}")
        end if options[:scopes]

        values.each do |val|
          define_method(:"#{attribute}_#{val}?") { self.send(attribute) == val }
        end if options[:query_methods] != false

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
          return nil unless self.send(attribute)

          defaults  = ["activerecord.attributes.#{self.class.klass_key}.#{attribute}_enum.#{self.send(attribute)}"]
          defaults << self.send(attribute).to_s.humanize
          I18n.translate(defaults.shift, :default => defaults, :raise => true)
        end
      end

      def values_for_select_tag(enum)
        values = enum(enum)
        begin
          translation = I18n.translate("activerecord.attributes.#{self.klass_key}.#{enum}_enum", :raise => true)

          values.map { |value| [translation[value.to_sym], value] }
        rescue I18n::MissingTranslationData
          values.map { |value| [value.to_s.humanize, value] }
        end
      end

      def klass_key
        self.model_name.respond_to?(:i18n_key) ? self.model_name.i18n_key : self.name.underscore
      end
    end
  end
end
