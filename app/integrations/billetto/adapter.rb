require "uri"
require "net/http"
require "json"

module Billetto
  class Adapter
    # Change this
    BASE_URL = "https://billetto.dk/api/v3"

    def initialize(api_keypair:)
      @api_keypair = api_keypair
    end

    def public_events(limit:)
      # change this
      get("/public/events", limit: limit)
    end

    private

    def get(path, params = {})
      uri = URI("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri)
      request["Accept"] = "application/json"
      request["Api-Keypair"] = @api_keypair

      response = http.request(request)

      handle_response(response)
    rescue Net::HTTPError, Timeout::Error, SocketError => e
      raise Billetto::ApiError, e.message
    end

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      when Net::HTTPUnauthorized
        raise Billetto::AuthenticationError, "Billetto authentication failed"
      else
        raise Billetto::ApiError,
              "Billetto API returned #{response.code}: #{response.body}"
      end
    end
  end
end
