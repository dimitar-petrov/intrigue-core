module Intrigue
  module Issue
  class GenericContentIssue < BaseIssue
  
    def self.generate(instance_details={})
      to_return = { 
        name: "generic_content_issue",
        pretty_name: "Generic Content Issue",
        category: "application",
        source: instance_details["check"],
        severity: 4, 
        status: "confirmed",
        description: "This server had a content issue: #{instance_details["check"]}.",
        references: [],
        details: {
          uri: instance_details["uri"],
          check: instance_details["check"]
        }
      }.merge!(instance_details)
  
    to_return
    end
  
  end
  end
  end
  