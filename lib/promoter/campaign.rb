module Promoter

  class Campaign

    API_URL =  "https://app.promoter.io/api/campaigns"

    attr_reader :id, :name, :drip_duration, :contact_count, :eligible_count,
                :last_surveyed_date, :launch_date

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @drip_duration = attrs["drip_duration"]
      @contact_count = attrs["all_count"]
      @eligible_count = attrs["eligible_count"]
      @last_surveyed_date = Time.parse(attrs["last_surveyed_date"]) if attrs["last_surveyed_date"]
      @launch_date = Time.parse(attrs["launch_date"]) if attrs["launch_date"]
    end

    def self.all(page=1)
      response = Request.get("#{API_URL}/?page=#{page}")
      response['results'].map {|attrs| new(attrs)}
    end

    # Parameter     Optional?  Description
    # all_contacts	yes	       Can be set to true,false
    #                          If set to true, the call will send surveys to all
    #                          contacts in your specified contact list.
    #                          If set to false, the call will send surveys to
    #                          contacts who have been added or updated since you
    #                          last sent surveys. The default behavior is when
    #                          all_contacts is set to false.
    def self.send_surveys(campaign_id, all_contacts=false)
      raise "this doesn't work needs to not parse the response as json"
      response = Request.post("#{API_URL}/#{campaign_id}/send-surveys/",
                              { all_contacts: all_contacts })
      response[0] == 'surveys sent'
    end
  end
end