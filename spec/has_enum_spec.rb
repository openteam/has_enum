# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HasEnum::ActiveRecord do
  before :each do
    @model = TestModel.new(:category => 'misc', :color => 'blue', :foo => 'bar', :status => :pending)
  end

  it "should return the values for a given enum attribute" do
    TestModel.enum[:category].should eql(%w(stuff things misc))
  end

  it "should return array of translated values for attribute" do
    I18n.reload!
    TestModel.human_enum(:status).should eql ["На рассмотрении", "Обработано с ошибкой", "Завершено"]
    TestModel.human_enum(:category).should eql ['Stuff', 'Things', 'Misc']
  end
  
  it "should return hash of attributes with translated values for each" do
    I18n.reload!
    TestModel.human_enum.should eql Hash[:category=>["Stuff", "Things", "Misc"],
                                         :color=>["Red", "Green", "Blue"],
                                         :size=>["Small", "Medium", "Large"],
                                         :status=>["На рассмотрении", "Обработано с ошибкой", "Завершено"]]
  end

  describe "category enum" do
    it "should accept enum values for the attribute" do
      %w(stuff things misc).each do |value|
        @model.category = value
        @model.should be_valid
      end
    end

    it "should accept nil value for the attribute" do
      @model.category = nil
      @model.category.should be_nil
    end

    it "should reject non enum values for the attribute" do
      @model.category = 'objects'
      @model.errors[:category].size.should eql(1)
    end

    it "should define query methods for enum values" do
      %w( stuff things misc ).each do |value|
        @model.should respond_to(:"category_#{value}?")
      end
    end
  end

  describe "color enum" do
    it "should accept any value for the attribute" do
      %w(red orange yellow).each do |value|
        @model.color = value
        @model.should be_valid
      end
    end

    it "should reject an empty value for the attribute" do
      @model.color = ''
      @model.errors[:color].size.should eql(1)
    end

    it "should define a query method for each enum value" do
      @model.color     = 'green'
      @model.category  = 'stuff'
      @model.should be_category_stuff
      @model.should be_color_green
      @model.should_not be_color_red
      @model.should_not be_color_blue
    end

    it "should define a scope for each enum value" do
      @model.color = 'red'
      @model.save
      @model2 = TestModel.new(:color => 'red')
      @model2.save

      TestModel.color_red.all.should eql TestModel.where(:color => 'red').all
      TestModel.color_green.all.should be_empty
    end
  end

  describe "size enum" do
    it "should accept any value for the attribute" do
      ['orange', 'medium', 'misc', '', nil].each do |value|
        @model.size = value
        @model.should be_valid
      end
    end

    it "should not define query methods for enum values" do
      %w(small medium large).each do |value|
        @model.should_not respond_to(:"size_#{value}?")
      end
    end

    it "should return humanized translation if not localized" do
      @model.size = 'medium'
      @model.human_size.should eql("Medium")
    end
  end

  describe "status enum" do
    it "should accept symbols as symbols" do
      @model.status = :pending
      @model.status.should eql(:pending)
    end

    it "should define query methods for enum values" do
      @model.status = :pending
      @model.should be_status_pending
    end

    it "should accept nil value for the attribute" do
      @model.status = nil
      @model.status.should be_nil
    end

    it "should translate values for the enum" do
      I18n.reload!
      @model.status = :pending
      @model.human_status.should eql("На рассмотрении")
    end
  end
end