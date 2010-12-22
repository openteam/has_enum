# has_enum

Gem for Rails 3 app to easily handle enumeration attributes in models.

## Installation and configuration

This gem has been designed for Rails 3 only.

### Install gem

Insert
    gem 'has_enum'
in your Rails 3 Gemfile. Then do
    $ bundle install

## Usage
### Models
Here's example model:
    class TestModel < ActiveRecord::Base
      has_enum :category, %w( stuff things misc )
      has_enum :color   , %w( red green blue )
      has_enum :size    , %w( small medium large )   , :query_methods => false
      has_enum :status  , [:pending, :failed, :done]
    end
Query methods are available by default. For example, query methods for color enum this methods will be available:
      color_green?
      color_red?
      color_blue?
See [sample usage in specs](https://github.com/openteam/has_enum/blob/master/spec/has_enum_spec.rb).

### Views
    radio_button_enum(object_name, method, options = {})
    select_enum(object_name, method, options = {})
#### Usage with Formtastic (Monkeypatch)
If you are using another gems that inherited from formtastic the most simple method will be to add this code
in your *config/initializers/formtastic.rb*:
    class Formtastic::SemanticFormBuilder
      def enum_input(method, options = {})
        value = @object.send(method)
        additional_params = {:as => :select, :collection => @object.class.values_for_select_tag(method)}
        self.input(method, options.merge(additional_params)).gsub(/class="select/, 'class="enum')
      end
    end
Or if you sure you don't use any the proper method is to inherit from it:
    class CustomBuilder < Formtastic::SemanticFormBuilder
      def enum_input(method, options = {})
        value = @object.send(method)
        additional_params = {:as => :select, :collection => @object.class.values_for_select_tag(method)}
        self.input(method, options.merge(additional_params)).gsub(/class="select/, 'class="enum')
      end
    end
And uncomment
    Formtastic::SemanticFormHelper.builder = CustomBuilder

## Running Tests

Run the tests
    rake spec
View specs are still failing. I'm working on it.

## Contributing to has_enum
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2010 Andreas Korth, Konstantin Shabanov. See LICENSE.txt for
further details.
