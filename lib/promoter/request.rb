require 'httparty'
require 'json'

module Promoter

  class Request

    include HTTParty
    extend Errors

    def self.get(url)
      response = HTTParty.get(url, headers: auth_header)
      parse_response(response)
    end

    def self.post(url, params)
      response_format = params.delete(:response_format) || :json
      response = HTTParty.post(url, body: params.to_json, headers: auth_header)
      parse_response(response, response_format)
    end

    def self.delete(url)
      response = HTTParty.delete(url, headers: auth_header)
      parse_response(response)
    end

    private

    def self.parse_response(response, response_format=:json)
      display_debug(response.body)
      response_body = begin
                        JSON.parse(response.body.to_s)
                      rescue
                        response.body.to_s
                      end
      check_for_error(response.response.code, response_body)
      response_body
    end

    def self.display_debug(response)
      if Promoter.debug
        puts "-" * 20 + " DEBUG " + "-" * 20
        puts response
        puts "-" * 18 + " END DEBUG " + "-" * 18
      end
    end

    def self.auth_header
      if Promoter.api_key.nil?
        raise Errors::Unauthorized.new("You need to set your promoter api key. You can register for a Promoter API key with a Promoter.io Account.")
      end
      { "Authorization" => "Token #{Promoter.api_key}",
        'Content-Type' => 'application/json' }
    end

  end

end
