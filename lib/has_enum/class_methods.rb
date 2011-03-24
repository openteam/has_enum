module HasEnum::ClassMethods

  def enums
    @enums ||= read_inheritable_attribute(:enums)
  end

  def has_enum(*params)
    options = params.extract_options!
    options.assert_valid_keys(:query_methods, :scopes, :presence)

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

      validates attribute, :inclusion => { :in => values + [nil]}
      validates attribute, :presence => options[:presence] if options[:presence]

      values.each do |val|
        scope "#{attribute}_#{val}", where(attribute => val)
      end if options[:scopes]

      values.each do |val|
        define_method "#{attribute}_#{val}?" do
           self.send(attribute) == val.to_s
        end
      end if options[:query_methods] != false

      define_method "human_#{attribute}" do
        self.class.human_enums[attribute][self[attribute]]
      end

      define_method "#{attribute}=" do | value |
        value = value.to_s
        value = nil if value == ''
        self[attribute] = value
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
    begin
      options = {:default => nil, :raise => true, :count => nil}
      HashWithIndifferentAccess.new(human_attribute_name("#{enum}_enum", options))
    rescue I18n::MissingTranslationData
      (enums[enum] || []).inject HashWithIndifferentAccess.new do |hash, value|
        hash[value] = value.humanize
        hash
      end
    end
  end

end

