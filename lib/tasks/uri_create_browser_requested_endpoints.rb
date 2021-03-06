module Intrigue
module Task
class UriCreateBrowserRequestedEndpoints < BaseTask

  def self.metadata
    {
      :name => "uri_create_browser_requested_endpoints",
      :pretty_name => "URI Create Browser-Requested Endpoints",
      :authors => ["jcran"],
      :description =>  "This task creates entities for every requested uri",
      :references => [],
      :type => "discovery",
      :passive => true,
      :allowed_types => ["Uri"],
      :example_entities => [ { "type" => "Uri", "details" => {"name" => "http://www.intrigue.io"} }],
      :allowed_options => [
        {:name => "create_endpoints", :regex => "boolean", :default => true },
        {:name => "create_wsendpoints", :regex => "boolean", :default => true },
      ],
      :created_types => []
    }
  end

  def run

    require_enrichment

    if _get_option("create_endpoints")
      _log "Creating broswer endpoints"
      if browser_responses = _get_entity_detail("extended_browser_responses")
        _log "Creating #{browser_responses.count} endpoints"
        browser_responses.each do |r|
          next unless "#{r["uri"]}" =~ /^http/i
          _create_entity("Uri", {"name" => r["url"] }) 
        end
      else 
        _log_error "Unable to create entities, missing 'extended_responses' detail"
      end
    else
      _log "Skipping normal browser responses"
    end

    if _get_option("create_wsendpoints")
      if browser_responses = _get_entity_detail("extended_browser_wsresponses")
        browser_responses.each do |r|
          next unless "#{r["uri"]}" =~ /^http/i
          _create_entity("Uri", {"name" => r["url"] })
        end
      else 
        _log_error "Unable to create entities, missing 'extended_responses' detail"
      end
    else 
      _log "Skipping webservice browser responses"
    end

  end

end
end
end
