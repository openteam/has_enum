require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HasEnum::ActiveRecord do
  
  before :each do
    @model = Model.new(:category => 'misc', :color => 'blue', :foo => 'bar')
  end
  
  it "should return the values for a given enum attribute" do
    Model.enum[:category].should eql(%w(stuff things misc))
  end
  
  describe "category enum" do
  
    it "should accept enum values for the attribute" do
      %w(stuff things misc).each do |value|
        @model.category = value
        @model.should be_valid
      end
    end
    
    it "should reject non enum values for the attribute" do
      @model.category = 'objects'
      @model.should have(1).error_on(:category)
    end
    
    it "should define a query method with the prefix 'in_' for each enum value" do
      @model.category = 'things'
      @model.in_stuff?  .should be_false
      @model.in_things? .should be_true
      @model.in_misc?   .should be_false
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
      @model.should have(1).error_on(:color)
    end
    
    it "should define a query method for each enum value" do
      @model.color = 'green'
      @model.red?   .should be_false
      @model.green? .should be_true
      @model.blue?  .should be_false
    end
    
    it "should define a named scope for each enum value" do
      Model.red.proxy_options.should eql({
        :conditions => {:color => 'red'}
      })
      Model.green.proxy_options.should eql({
        :conditions => {:color => 'green'}
      })
      Model.blue.proxy_options.should eql({
        :conditions => {:color => 'blue'}
      })
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
      [:small?, :medium?, :large?].each do |method|
        @model.respond_to?(method).should be_false
        @model.should_not respond_to(method)
      end
    end
  end

  describe "foo enum" do

    it "should accept attribute values starting with 'bar'" do
      ['bar', 'barcode', 'bargain'].each do |value|
        @model.foo = value
        @model.should be_valid
      end
    end
    
    it "should reject attribute values not starting with 'bar'" do
      %w(foo unbar).each do |value|
        @model.foo = value
        @model.should have(1).error_on(:foo)
      end
    end
  end
end