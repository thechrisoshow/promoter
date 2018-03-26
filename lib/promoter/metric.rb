module Promoter

  class Metric

    attr_accessor :campaign_name, :nps, :organization_nps

    API_URL = "https://app.promoter.io/api/metrics"

    def initialize(attrs)
      @campaign_name = attrs["campaign"]
      @nps = attrs["nps"].to_f
      @organization_nps = attrs["organization_nps"].to_f
    end

    def self.all(options={})
      query_string = URI.encode_www_form(options)
      response = Request.get("#{API_URL}/?#{query_string}")
      response['results'].map {|attrs| new(attrs)}
    end

  end
end