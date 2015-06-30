module Promoter

  class Metric

    attr_accessor :campaign_name, :nps, :organization_nps

    API_URL = "https://app.promoter.io/api/metrics"

    def initialize(attrs)
      @campaign_name = attrs["campaign"]
      @nps = attrs["nps"].to_f
      @organization_nps = attrs["organization_nps"].to_f
    end

    def self.all(page=1)
      response = Request.get("#{API_URL}/?page=#{page}")
      response['results'].map {|attrs| new(attrs)}
    end

  end
end