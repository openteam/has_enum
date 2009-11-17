class Model < ActiveRecord::Base  
  has_enum :category, %w( stuff things misc ) , :query_methods => :in
  has_enum :color   , %w( red green blue )    , :query_methods => true, :validate => :presence, :named_scopes => true
  has_enum :size    , %w( small medium large ), :validate => false
  has_enum :foo     , %w( bar )               , :validate => lambda{ |model, attrib, value|
    model.errors.add(attrib, :unbar) unless value =~ /^bar/ }
end

