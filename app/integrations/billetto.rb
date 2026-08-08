module Billetto
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class ApiError < Error; end

  class Events
    def self.sync
      new.sync
    end

    def initialize(adapter: Rails.configuration.billetto)
      @adapter = adapter
    end

    def sync
      response = @adapter.public_events(limit: 10)

      response.fetch("data", []).each do |event|
        e = Event.find_or_initialize_by(billetto_id: event["id"])
        e.title = event["title"]
        e.description = event["description"]
        e.start_date = event["startdate"]
        e.end_date = event["enddate"]
        e.image_url = event["image_link"]
        e.created_at = Time.current
        e.updated_at = Time.current
        e.save if e.valid?
      end
    rescue Billetto::Error
      raise
    rescue StandardError => e
      raise Billetto::Error, e.message
    end
  end
end
