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
          values.each do |value|
            named_scope value.to_sym, :conditions => {attribute => value}
          end
        end

        validate = options.delete(:validate)
      
        case validate
        when :inclusion, nil, true  then validates_inclusion_of(attribute, options.merge(:in => values))
        when :presence              then validates_presence_of(attribute, options)
        when Proc                   then validates_each(attribute, options, &validate)
        end
    
        define_method(:"#{attribute}=") do |value|
          write_attribute(attribute, value ? value.to_s : nil)
        end
      end
    end
  end
end
