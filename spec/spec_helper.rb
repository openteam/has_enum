$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rails/all'
require 'has_enum'

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => 'spec/rspec.db'
)

ActiveRecord::Schema.define(:version => 0) do
  create_table "test_models", :force => true do |t|
    t.string "category"
    t.string "color"
    t.string "size"
    t.string "status"
    t.string "foo"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end
end

I18n.load_path << 'spec/ru.yml'
I18n.default_locale = :ru

require File.dirname(__FILE__) + "/test_model" unless defined?(Model)