require 'has_enum/active_record'
require 'has_enum/helpers'
# module HasEnum; end

ActiveRecord::Base.send(:include, HasEnum::ActiveRecord)
ActionView::Helpers::InstanceTag.send(:include, HasEnum::Helpers::InstanceTag)
ActionView::Helpers::FormHelper.send(:include, HasEnum::Helpers::FormHelper)
ActionView::Helpers::FormBuilder.send(:include, HasEnum::Helpers::FormBuilder)