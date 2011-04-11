class TestModel < ActiveRecord::Base

  has_enum :category,           %w[stuff things misc],      :presence       => {:on => :update}

  has_enum :color,              %w[red green blue],         :scopes         => true

  has_enum :size,                                           :query_methods  => false

  has_enum ["status", :state],  [:pending, :failed, :done], :presence       => true

  has_enum :speed,              %w[slow normal fast],       :multiple       => true, :presence => true

end

