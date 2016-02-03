module Promoter

  class EmailTemplate

    API_URL =  "https://app.promoter.io/api/email"

    attr_reader :id, :name, :subject, :reply_to_email, :from_name,
                :intro_message, :language, :company_brand_product_name

    def initialize(attrs)
      @id = attrs["id"]
      @name = attrs["name"]
      @subject = attrs["subject"]
      @reply_to_email = attrs["reply_to_email"]
      @from_name = attrs["from_name"]
      @intro_message = attrs["intro_message"]
      @language = attrs["language"]
      @company_brand_product_name = attrs["company_brand_product_name"]
    end

    def self.all(page=1)
      response = Request.get("#{API_URL}/?page=#{page}")
      response['results'].map {|attrs| new(attrs)}
    end

    # Email Template Params
    # Parameter                   Optional?  Description
    # name                        no         The name of the email template
    # subject                     no         The subject line of the email template
    # reply_to_email              no         The reply-to email address for the email template
    # from_name                   no         The name the template is showing to be from
    # intro_message               no         This is the message that appears just above 
    #                                        the 0-10 scale and below the logo
    # language                    no         The language the template is in
    # company_brand_product_name  no         The name inserted into the main question
    def self.create(attributes)
      response = Request.post(API_URL + "/", attributes)
      new(response)
    end

  end
end