module HasEnum
  module ActiveRecord
    
    def self.included(base)
      base.write_inheritable_hash(:enum, {})
      base.extend(ClassMethods)
    end
  
    module ClassMethods
    
      def enum(attribute = nil)
        @enum ||= read_inheritable_attribute(:enum)
        attribute ? @enum[attribute] : @enum
      end
    
      def has_enum(attribute, values, options = {})
        options.assert_valid_keys(:validate, :query_methods, :named_scopes, :symbol)

        values.map!(&:to_sym) if options[:symbol]
        
        enum[attribute] = values.freeze
    
        if query_methods = options.delete(:query_methods)
          method_prefix = query_methods if query_methods.is_a?(Symbol)
          values.each do |value|
            method_name = "#{value.parameterize.underscore}?"
            method_name = "#{method_prefix}_#{method_name}" if method_prefix
            raise NameError, "Query method '#{method_name}' is already defined" if instance_methods.include?(method_name)
            define_method(method_name) do
              send(attribute) == value
            end
          end
        end
        
        if named_scopes = options.delete(:named_scopes)
          scope_prefix = named_scopes if named_scopes.is_a?(Symbol)
          values.each do |value|
            scope_name = "#{value.parameterize.underscore}"
            scope_name = "#{scope_prefix}_#{scope_name}" if scope_prefix
            named_scope scope_name, :conditions => { attribute => value }
          end
        end

        validate = options.delete(:validate)
      
        case validate
        when :inclusion, nil, true  then validates_inclusion_of(attribute, options.merge(:in => values))
        when :presence              then validates_presence_of(attribute, options)
        when Proc                   then validates_each(attribute, options, &validate)
        end
    
        if options[:symbol]
          define_method(attribute) do
            if value = read_attribute(attribute)
              value.to_sym
            end
          end
        end
        
        define_method(:"#{attribute}=") do |value|
          write_attribute(attribute, value.blank? ? nil : value.to_s)
        end          
      end
    end
  end
end
