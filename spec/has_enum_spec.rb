# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HasEnum do
  let :model do
    TestModel.new(:category => :stuff, :status => :pending, :state => :done, :speed => :slow)
  end

  let :human_enums do
    {
      :category => {
        :stuff    => 'Stuff',
        :things   => 'Things',
        :misc     => 'Misc'
      },
      :color    => {
        :red      => 'Red',
        :green    => 'Green',
        :blue     => 'Blue'
      },
      :size => {
        :small    => "Маленький",
        :medium   => "Средний",
        :large    => "Большой"
      },
      :status => {
        :pending  => 'На рассмотрении',
        :failed   => "Обработано с ошибкой",
        :done     => "Завершено"
      },
      :state => {
        :pending  => 'Pending',
        :failed   => 'Failed',
        :done     => 'Done'
      },
      :speed => {
        :slow     => 'Медленный',
        :normal   => 'Нормальный',
        :fast     => 'Быстрый'
      }
    }.with_indifferent_access
  end

  it "should have has_enum? and has_multiple_enum? methods" do
    TestModel.should be_has_enum(:state)
    TestModel.should be_has_multiple_enum(:speed)
    TestModel.should_not be_has_enum(:some_attribute)
    TestModel.should_not be_has_multiple_enum(:status)
  end

  it "should return values by name symbol" do
    TestModel.enums[:state].should eql human_enums[:state].stringify_keys.keys
  end

  it "should return values by name string" do
    TestModel.enums["state"].should eql human_enums[:state].stringify_keys.keys
  end

  it "should return the values for a given enum attribute" do
    TestModel.enums[:category].should eql human_enums[:category].stringify_keys.keys
  end

  it "should return hash of values with it's translated equivalent" do
    TestModel.human_enums[:size].should     eql human_enums[:size]
    TestModel.human_enums[:status].should   eql human_enums[:status]
    TestModel.human_enums[:category].should eql human_enums[:category]
  end

  it "should return hash of enums with hashes of attributes and theirs translated equivalent" do
    TestModel.human_enums.should eql human_enums
  end

  it "should return translated value for attribute" do
    TestModel.human_enums[:size][:large].should eql "Большой"
    TestModel.human_enums[:color][:red].should eql "Red"
    TestModel.human_enums[:status][:done].should eql "Завершено"
  end

  it "should autodetect all enums if has_enums called" do
    AnotherModel.should     be_has_multiple_enum(:speed)

    AnotherModel.should_not be_has_multiple_enum(:size)
    AnotherModel.should     be_has_enum(:size)

    AnotherModel.should     be_has_enum(:status)
  end

  describe "category enum" do
    it "should accept string enum values" do
      %w(stuff things misc).each do |value|
        model.category = value
        model.should be_valid
      end
    end

    it "should accept symbol enum values" do
      %w(stuff things misc).each do |value|
        model.category = value.to_sym
        model.should be_valid
      end
    end

    it "should reject not enum values" do
      model.category = "not_listed_in_enum"
      model.should_not be_valid
    end

    it "should accept nil value for the attribute on create" do
      model.category = nil
      model.should be_valid
    end

    it "should not accept nil value for the attribute on update" do
      model.save
      model.category = nil
      model.should_not be_valid
    end

    it "should not accept blank value for the attribute" do
      model.category = '   '
      model.should_not be_valid
    end

    it "should normalize empty value for the attribute" do
      model.category = ''
      model.category.should be_nil
    end

    it "should define query methods for enum values" do
      %w[stuff things misc].each do |value|
        model.should respond_to(:"category_#{value}?")
      end
    end

    it "query methods should works" do
      model.category = :stuff
      model.should     be_category_stuff
      model.should_not be_category_things
      model.should_not be_category_misc

      model.category = :things
      model.should_not be_category_stuff
      model.should     be_category_things
      model.should_not be_category_misc

      model.category = :misc
      model.should_not be_category_stuff
      model.should_not be_category_things
      model.should     be_category_misc
    end

    it "should not define a scope methods for each enum value" do
      TestModel.should_not respond_to :category_stuff
      TestModel.should_not respond_to :category_things
      TestModel.should_not respond_to :category_misc
    end

    it "should translate category by human_category method" do
      model.human_category.should eql 'Stuff'
    end
  end

  describe "color enum" do
    it "should define a scope for each enum value" do
      model.color = 'red'
      model.save

      model2 = model.dup
      model2.color = :blue
      model2.save

      TestModel.color_red.all.should eql TestModel.where(:color => 'red').all

      TestModel.color_red.should be_one
      TestModel.color_blue.should be_one
      TestModel.color_green.count.should be_zero
    end

    it "should accept nil value for the attribute" do
      model.color = nil
      model.should be_valid
      model.save
      model.should be_valid
    end

    it "should accept blank value for the attribute" do
      model.color = ''
      model.should be_valid
      model.save
      model.should be_valid
    end
  end

  describe "size enum" do
    it "should not define query methods for enum values" do
      %w(small medium large).each do |value|
        model.should_not respond_to(:"size_#{value}?")
      end
    end

    it "should accept not enum values" do
      model.size = 'stuff'
      model.should be_valid
    end
  end

  describe "status enum" do
    it "should not accept nil value for the attribute" do
      model.status = nil
      model.should_not be_valid
    end

    it "should not accept blank value for the attribute" do
      model.status = ''
      model.should_not be_valid
    end
  end

  describe "speed enum" do
    it "should return empty array for nil speed" do
      model.speed = nil
      model.speed.should eql []
      model.should_not be_valid
    end

    it "empty array is not valid value for speed" do
      model.speed = []
      model.should_not be_valid
    end

    it "should support multiple values for attribute" do
      model.speed = [:normal, :fast]
      model.should be_valid
    end

    it "should return nil for human_speed if speed not initialized" do
      model.speed = []
      model.human_speed.should be_nil
    end

    it "should return array of translated values for human_speed" do
      model.speed = [:normal, :fast]
      model.human_speed.should eql %w[Нормальный Быстрый]
    end

    it "should return array of string values for speed, even if initialized by symbols" do
      model.speed = [:normal, :fast]
      model.speed.should eql %w[normal fast]
    end
  end
end
