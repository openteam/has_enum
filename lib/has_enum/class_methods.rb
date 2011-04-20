module HasEnum::ClassMethods

  def enums
    read_inheritable_attribute(:enums) ||
      write_inheritable_attribute(:enums, HashWithIndifferentAccess.new)
  end

  def enum_values(attribute)
    enums[attribute]
  end

  def has_enum?(enum)
    enums.include? enum
  end

  def has_multiple_enum?(enum)
    has_enum?(enum) && serialized_attributes[enum.to_s] == Array
  end

  def has_enums
    columns_hash.each do | column_name, column |
      if human_attribute_name("#{column_name}_enum", :count => nil).is_a? Hash
        if column.type == :text
          has_enum column_name, :multiple => true
        else
          has_enum column_name
        end
      end
    end
  end

  def has_enum(*params)
    options = params.extract_options!
    options.assert_valid_keys(:query_methods, :scopes, :presence, :multiple)

    raise ArgumentError, "Empty arguments list for has_enum call" if params.empty?

    default_values = nil
    case params.second
      when NilClass                   # has_enum :enum
        attributes = [*params.first]
      when Array                      # has_enum :enum, %w[foo bar]
        attributes = [*params.first]
        default_values = params.second.map(&:to_s)
      else                            # has_enum :state, :status
        attributes = params
    end

    attributes.map(&:to_sym).each do | attribute |
      values = default_values || human_enum_values(attribute).keys.map(&:to_s)

      enums[attribute] = values

      if options[:multiple]
        serialize attribute, Array
      else
        validates attribute, :inclusion => { :in => values + [nil]}
      end

      validates attribute, :presence => options[:presence] if options[:presence]

      values.each do |val|
        scope "#{attribute}_#{val}", where(attribute => val)
      end if options[:scopes]

      values.each do |val|
        define_method "#{attribute}_#{val}?" do
           self.send(attribute) == val.to_s
        end
      end if options[:query_methods] != false

      if options[:multiple]
        define_method "human_#{attribute}" do
          return nil if self.send(attribute).empty?
          self.send(attribute).map{|v| self.class.human_enums[attribute][v]}
        end
      else
        define_method "human_#{attribute}" do
          self.class.human_enums[attribute][self[attribute]]
        end
      end

      if options[:multiple]
        define_method "#{attribute}=" do | values |
          self[attribute] = [*values].compact.map(&:to_s).delete_if{|v| v.blank?}
        end
      else
        define_method "#{attribute}=" do | value |
          value = value.to_s
          value = nil if value == ''
          self[attribute] = value
        end
      end

      if options[:multiple]
       define_method attribute do
         self[attribute] ||= []
       end
      end
    end
  end


  def human_enums
    @human_enums ||= enums.keys.inject HashWithIndifferentAccess.new do | hash, enum |
      hash[enum] = human_enum_values enum
      hash
    end
  end

  def human_enum_values(enum)
    values = human_attribute_name("#{enum}_enum", :count => nil)
    unless values.is_a? Hash
      values = (enums[enum] || []).inject({}) do |hash, value|
        hash[value] = value.humanize
        hash
      end
    end
    values.with_indifferent_access
  end


  def values_for_select_tag(enum)
    (human_enums[enum] || human_enum_values(enum)).invert.to_a
  end

end

