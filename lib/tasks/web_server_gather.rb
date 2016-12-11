module Intrigue
class WebServerGather < BaseTask
  include Intrigue::Task::Web

  def self.metadata
    {
      :name => "web_server_gather",
      :pretty_name => "Web Server Gather",
      :authors => ["jcran"],
      :description => "Web Server Gather",
      :references => [],
      :type => "discovery",
      :passive => false,
      :allowed_types => ["Uri"],
      :example_entities => [{"type" => "Uri", "attributes" => {"name" => "https://intrigue.io"}}],
      :allowed_options => [],
      :created_types => ["WebServer"]
    }
  end

  def run
    super
    # Grab the full response 2x
    response = http_get _get_entity_name
    response2 = http_get _get_entity_name

    web_server_name = resolve_header_name(response.header['server'])

    if response.header['server']
      # If we got the same 'server' header in both, create a WebServer entity
      # Checking for both gives us some assurance it's not totally bogus (e)
      # TODO: though this might miss something if it's a different resolution path?
      if response.header['server'] == response2.header['server']
        _log_good "Creating header for #{web_server_name}"
        _create_entity "WebServer", { "name" => web_server_name }
      else
        _log_error "Header did not match!"
        _log_error "1: #{response.header['server']}"
        _log_error "2: #{response2.header['server']}"
      end
    else
      _log_error "No 'server' header!"
    end

  end

  # This method resolves a header to a probable name in the case of generic
  # names. Otherwise it just matches what was sent.
  def resolve_header_name(header_content)

    # Sometimes we're given a generic name, so keep track of the probable server for that name
    aliases = [
      {:given => "Server", :probably => "Apache"}
    ]

    # Set the default
    web_server_name = header_content

    # Check all aliases, returning the probably name if it matches exactly
    aliases.each { |a| web_server_name = a[:probably] if a[:given] == header_content }

  web_server_name
  end

end
end