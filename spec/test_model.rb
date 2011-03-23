class TestModel < ActiveRecord::Base

  has_enum :category,           %w[stuff things misc],      :presence       => {:on => :update}

  has_enum :color,              %w[red green blue],         :scopes         => true

  has_enum :size,               %w[small medium large],     :query_methods  => false

  has_enum ["status", :state],  [:pending, :failed, :done], :presence       => true

end

