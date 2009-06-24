require File.dirname(__FILE__) + '/../spec_helper'

describe ActionView::Helpers::FormHelper do
  
  before :each do
    @model = Model.new
  end
  
  it "should produce a select_enum tag" do
    html = [
      %(<select id="model_category" name="model[category]"><option value="stuff">Stuff</option>),
      %(<option value="things">Things</option>),
      %(<option value="misc">Misc</option></select>)
    ].join($/)
    
    fields_for(:model) do |fields|
      fields.select_enum(:category).should eql(html)
    end
  end

  it "should produce a radio_button_enum tag" do
    html = [
      %(<input id="model_size_small" name="model[size]" type="radio" value="small" />),
      %(<label for="model_size_small">Small</label>),
      %(<input id="model_size_medium" name="model[size]" type="radio" value="medium" />),
      %(<label for="model_size_medium">Medium</label>),
      %(<input id="model_size_large" name="model[size]" type="radio" value="large" />),
      %(<label for="model_size_large">Large</label>)
    ].join($/)
    
    fields_for(:model) do |fields|
      fields.radio_button_enum(:size).should eql(html)
    end
  end
end

