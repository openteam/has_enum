module HasEnum::ClassMethods

  def enum(attribute = nil)
    @enum ||= read_inheritable_attribute(:enum)
    attribute ? @enum[attribute] : @enum
  end

  def has_enum(attribute, values, options = {})
    options.assert_valid_keys(:query_methods, :scopes, :allow_nil)
    values = values.map(&:to_s)
    values << nil if options[:allow_nil]
    enum[attribute] = values.freeze

    validates attribute, { :inclusion => { :in => values} }

    values.each do |val|
      scope "#{attribute}_#{val}", where(attribute => val)
    end if options[:scopes]

    values.each do |val|
      define_method "#{attribute}_#{val}?" do
         self.send(attribute) == val.to_s
      end
    end if options[:query_methods] != false

    define_method "human_#{attribute}" do
      self.class.human_enum[attribute][self[attribute]]
    end

    define_method "#{attribute}=" do | value |
      value = value.to_s
      value = nil if value == ''
      self[attribute] = value
    end

  end

  def human_enum
    @human_enum ||= enum.keys.inject HashWithIndifferentAccess.new do | hash, attribute |
      hash[attribute] = human_enum_values attribute
      hash
    end
  end

  def human_enum_values(attribute)
    begin
      options = {:default => nil, :raise => true, :count => nil}
      HashWithIndifferentAccess.new(human_attribute_name("#{attribute}_enum", options))
    rescue I18n::MissingTranslationData
      enum(attribute).inject HashWithIndifferentAccess.new do |hash, value|
        hash[value] = value.humanize
        hash
      end
    end
  end

end

