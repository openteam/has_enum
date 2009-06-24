begin
  require 'hirb'
  require 'irb'
rescue LoadError; end

if defined? Hirb
  include Hirb::Console
  Hirb::View.enable unless Hirb::View.instance_variable_get(:@enabled)
  Hirb::View.render_method = lambda do |output|
    output = ERB::Util.html_escape(output).gsub(/\n/, "<br/>")
    puts "<pre>#{output}</pre>"
  end
end

class Object  
  def dbg(output)
    return if defined?(Hirb) && Hirb::View.render_output(output)
    output = output.inspect unless output.is_a?(String)
    output = ERB::Util.html_escape(output).gsub(/\n/, "<br/>")
    puts "<code>#{output}</code><br/>"
  end
end
