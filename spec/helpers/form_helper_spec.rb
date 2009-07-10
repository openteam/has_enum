require File.dirname(__FILE__) + '/../spec_helper'

describe ActionView::Helpers::FormHelper do
  
  before :each do
    @model = Model.new
    I18n.reload!
  end
  
  it "should produce a select_enum" do
    html = [
      %(<select id="model_category" name="model[category]"><option value="stuff">stuff</option>),
      %(<option value="things">things</option>),
      %(<option value="misc">misc</option></select>)
    ].join($/)
    
    fields_for(:model) do |fields|
      fields.select_enum(:category).should eql(html)
    end
  end

  it "should produce a radio_button_enum" do
    html = [
      %(<input id="model_size_small" name="model[size]" type="radio" value="small" />),
      %(<label for="model_size_small">small</label>),
      %(<input id="model_size_medium" name="model[size]" type="radio" value="medium" />),
      %(<label for="model_size_medium">medium</label>),
      %(<input id="model_size_large" name="model[size]" type="radio" value="large" />),
      %(<label for="model_size_large">large</label>)
    ].join($/)
    
    fields_for(:model) do |fields|
      fields.radio_button_enum(:size).should eql(html)
    end
  end

  describe "I18n" do
    before :each do
      I18n.locale = :de
      I18n.backend.store_translations(:de, YAML::load(<<-YAML
      activerecord: 
        attributes:
          model:
            category_enum:
              stuff:  'Zeug'
              things: 'Sachen'
              misc:   'Diverses'
            size_enum:
              small:  'Klein'
              medium: 'Mittel'
              large:  'Groß'
      YAML
      ))
    end

    it "should produce translated options for a select_enum" do
      html = fields_for(:model) do |fields|
        fields.select_enum(:category)
      end
      html.should include(%(<option value="stuff">Zeug</option>))
      html.should include(%(<option value="things">Sachen</option>))
      html.should include(%(<option value="misc">Diverses</option>))
    end

    it "should translated labels for produce a radio_button_enum" do
      html = fields_for(:model) do |fields|
        fields.radio_button_enum(:size)
      end
      html.should include(%(<label for="model_size_small">Klein</label>))
      html.should include(%(<label for="model_size_medium">Mittel</label>))
      html.should include(%(<label for="model_size_large">Groß</label>))
    end
  end  
end

