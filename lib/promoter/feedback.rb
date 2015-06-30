module Promoter

  class Feedback

    attr_reader :id, :contact, :score, :score_type, :posted_date, :comment, :follow_up_url, :url

    API_URL =  "https://app.promoter.io/api/feedback"

    def initialize(attrs)
      @id = attrs["id"]
      @contact = Contact.new(attrs["contact"])
      @score = attrs["score"]
      @score_type = attrs["score_type"]
      @posted_date = Time.parse(attrs["posted_date"])
      @comment = attrs["comment"]
      @follow_up_url = attrs["followup_href"]
      @follow_up_href = attrs["href"]
    end

    # TIDY UP CHRIS
    # Parameter   Required Description
    # score	      false	   Filtering by score can be achieved with a range 0-10
    # score_type	false	   Filtering by score type can be achieved with a list of values promoter, detractor, passive
    # survey__campaign	false	Filtering by campaign can be achieved by the given id of your campaign id
# survey__campaign__status	false	Filtering by campaign status can be achieved by providing one of the campaign status values: ACTIVE, COMPLETE.
# NOTE: This url parameter does not require quotes around the value.
# e.g. (<api-url>?survey__campaign__status=ACTIVE)

    def self.all(attrs={})
      response = Request.get("#{API_URL}/?#{query_string(attrs)}")
      response['results'].map {|attrs| new(attrs)}
    end

    def self.find(id)
      response = Request.get("#{API_URL}/#{id}")
      new(response)
    end

    private

    def self.query_string(attrs)
      # campaign_id is preferable to survey_campaign (which is what promoter expects)
      if attrs.has_key?(:campaign_id)
        attrs[:survey_campaign] = attrs.delete(:campaign_id)
      end
      URI.encode_www_form(attrs)
    end

  end
end