require File.dirname(__FILE__) + "/boot"

Rails::Initializer.run do |config|
  config.plugin_paths << File.dirname(__FILE__) + "/../../../.."
  config.plugins = %w(has_enum)
  config.frameworks -= [ :active_resource, :action_mailer ]
  config.action_controller.session = {
    :session_key => '_test_session',
    :secret => 'acc34300465aa6fa3e6db3f1aa55fc3d4a4d033786f22fb29107771c6449adcd3ffa308bb2e9b69fea55cdcc6a7c9b117f57d9bbad722a71d498f6b759869e34'
  }
end