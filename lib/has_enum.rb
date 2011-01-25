require 'has_enum/active_record'
require 'has_enum/helpers'

ActiveRecord::Base.send(:include, HasEnum::ActiveRecord)
