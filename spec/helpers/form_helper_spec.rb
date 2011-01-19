require File.dirname(__FILE__) + '/../spec_helper'

describe ActionView::Helpers::FormHelper do
  before :each do
    @model = TestModel.new
    I18n.reload!
  end
  
  it "should produce a select_enum" do
    html = [
      %(<select id="model_category" name="model[category]"><option value="stuff">stuff</option>),
      %(<option value="things">things</option>),
      %(<option value="misc">misc</option></select>)
    ].join($/)
    form_for @model do |f|
      f.fields_for :model do |fields|
        fields.select_enum(:category).should eql(html)
      end
    end
  end

  it "should produce a radio_button_enum" do
    html = [
      %(<input id="model_status_pending" name="model[status]" type="radio" value="pending" />),
      %(<label for="model_status_pending">pending</label>),
      %(<input id="model_status_failed" name="model[status]" type="radio" value="failed" />),
      %(<label for="model_status_failed">failed</label>),
      %(<input id="model_status_done" name="model[status]" type="radio" value="done" />),
      %(<label for="model_status_done">done</label>)
    ].join($/)
    
    fields_for(:model) do |fields|
      fields.radio_button_enum(:status).should eql(html)
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
            status_enum:
              pending: 'In Arbeit'
              failed:  'Fehlgeschlagen'
              done:    'Erledigt'
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
        fields.radio_button_enum(:status)
      end
      html.should include(%(<label for="model_status_pending">In Arbeit</label>))
      html.should include(%(<label for="model_status_failed">Fehlgeschlagen</label>))
      html.should include(%(<label for="model_status_done">Erledigt</label>))
    end
  end
end