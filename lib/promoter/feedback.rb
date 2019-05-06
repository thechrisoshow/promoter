module Promoter

  class Feedback

    attr_reader :id, :contact, :score, :score_type, :posted_date, :comment,
                :follow_up_url, :url, :comment_updated_date, :status

    API_URL =  "https://app.promoter.io/api/feedback"

    def initialize(attrs)
      @id = attrs["id"]
      @contact = Contact.new(attrs["contact"]) if attrs["contact"]
      @score = attrs["score"]
      @score_type = attrs["score_type"]
      @posted_date = Time.parse(attrs["posted_date"]) if attrs["posted_date"]
      if attrs["comment_updated_date"]
        @comment_updated_date = Time.parse(attrs["comment_updated_date"])
      end
      @comment = attrs["comment"]
      @follow_up_url = attrs["followup_href"]
      @follow_up_href = attrs["href"]
      @status = attrs["status"]
    end

    # Parameter                 Required Description
    # score	                    false    Filtering by score can be achieved with
    #                                    a range 0-10
    # score_type	              false	   Filtering by score type can be achieved
    #                                    with a list of values promoter,
    #                                    detractor, passive
    # survey__campaign	        false	   Filtering by campaign can be achieved
    #                                    by the given id of your campaign id
    # survey__campaign__status	false	   Filtering by campaign status can be
    #                                    achieved by providing one of the
    #                                    campaign status values: ACTIVE, COMPLETE.
    # NOTE: This url parameter does not require quotes around the value.
    # e.g. (<api-url>?survey__campaign__status=ACTIVE)
    def self.all(attrs={})
      api_url = if Promoter.api_version == 1
        API_URL
      else
        "https://app.promoter.io/api/v2/feedback"
      end

      response = Request.get("#{api_url}/?#{query_string(attrs)}")
      response['results'].map {|attrs| new(attrs)}
    end

    def self.find(id)
      response = Request.get("#{API_URL}/#{id}")
      new(response)
    end

    def close
      if Promoter.api_version == 1
        raise "This method is only available in API v2 onwards"
      end

      api_url = "https://app.promoter.io/api/v2/feedback"
      Request.put("#{api_url}/#{id}/", { status: "CLOSED" })
    end

    private

    def self.query_string(attrs)
      URI.encode_www_form(attrs)
    end

  end
end
