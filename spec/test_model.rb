class TestModel < ActiveRecord::Base
  has_enum :category, %w( stuff things misc )
  has_enum :color   , %w( red green blue )
  has_enum :size    , %w( small medium large )   , :query_methods => false
  has_enum :status  , [:pending, :failed, :done] , :symbols => true
end