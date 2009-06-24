ActiveRecord::Schema.define(:version => 0) do

  create_table "models", :force => true do |t|
    t.string "category"
    t.string "color"
    t.string "size"
    t.string "foo"
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end
end
