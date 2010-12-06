require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe HasEnum::ActiveRecord do
  before :each do
    @model = TestModel.new(:category => 'misc', :color => 'blue', :foo => 'bar', :status => :pending)
  end
  
  it "should return the values for a given enum attribute" do
    TestModel.enum[:category].should eql(%w(stuff things misc))
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
      @model.errors[:category].size.should eql(1)
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
      @model.should be_stuff
      @model.should be_green
      @model.should_not be_red
      @model.should_not be_blue
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
      %w( small? medium? large? ).each do |method|
        @model.should_not respond_to(method)
      end
    end
  end

  describe "status enum" do
    it "should accept symbols as values" do
      @model.status = :pending
      @model.status.should eql("pending")
    end
    
    it "should define query methods for enum values" do
      @model.status = :pending
      @model.should be_pending
    end
  end

  describe "foo enum" do
    it "should accept attribute values starting with 'bar'" do
      ['bar', 'barcode', 'bargain'].each do |value|
        @model.foo = value
        @model.should be_valid
      end
    end
  end
end