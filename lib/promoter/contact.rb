module Promoter

  class Contact

    attr_reader :id, :email, :first_name, :last_name, :created_date, :attributes

    API_URL =  "https://app.promoter.io/api/contacts"

    def initialize(attrs)
      @id = attrs["id"]
      @email = attrs["email"]
      @first_name = attrs["first_name"]
      @last_name = attrs["last_name"]
      @created_date = Time.parse(attrs["created_date"]) if attrs["created_date"]
      @attributes = attrs["attributes"]
    end

    def destroy
      Contact.destroy(self.email)
    end

    # Parameter         Optional?  Description
    # page	            yes	       Returns which page of results to return. Defaults to 1
    #
    # email             yes        Filter the results by email address.
    # contact_list_id   yes        Filter the results by contact list
    def self.all(options={})
      if !options.is_a?(Hash)
        puts "-- DEPRECATION WARNING--"
        puts "Passing in a number as a page is deprecated and will be removed from future versions of this gem.\nInstead pass in a hash of attributes.\n\n e.g. Promoter::Contact.all(page: 2)"
        query_string = "page=#{options}"
      else
        # default to first page
        options[:page] ||= 1

        if options.key?(:contact_list_id)
          options[:contact_list__id] = options.delete(:contact_list_id)
        end

        query_string = URI.encode_www_form(options)
      end
      response = Request.get("#{API_URL}/?#{query_string}")
      response['results'].map { |attrs| new(attrs) }
    end

    def self.find(id)
      response = Request.get("#{API_URL}/#{id}")
      new(response)
    end

    def self.destroy(email)
      attributes = {
        email: email
      }
      response = Request.post("#{API_URL}/remove/", attributes)
      new(response)
    end

    # Contact Params
    # Parameter     Optional?  Description
    # email         no	       The email of the contact to add to the organization.
    # first_name	  yes	       The first name of the contact to add to the organization.
    # last_name	    yes	       The last name of the contact to add to the organization.
    # contact_list	yes	       A list of Contact List Id’s to associate a contact to.
    #                          If one is not provided the contact will be
    #                          associated to a default generated contact list.
    # attributes	  yes	       A dictionary of key value pairs of custom
    #                          attributes that will be associated with the
    #                          contact and contact list.
    # send	        yes	       A boolean value set to true in order to express
    #                          intent to survey this contact for a given campaign.
    # campaign	    yes	       The campaign id you would like to associate the
    #                          contact to. Note: Campaign must have a contact
    #                          list associated to it in order for the contact to
    #                          be added correctly. Otherwise, the contact will
    #                          be associated to a default generated contact list
    #                          for your given organization.
    def self.create(params)
      # ensure the values of the 'attributes' param are strings
      if params[:attributes]
        params[:attributes] = values_to_string(params[:attributes])
      end

      response = Request.post(API_URL + "/", params)
      new(response)
    end

    def self.survey(params)
      contact_attributes = if Promoter.api_version == 2
        api_url = "https://app.promoter.io/api/v2"
        response = Request.post(api_url + "/survey/", params)
        response["contact"]
      else
        Request.post(API_URL + "/survey/", params)
      end
      new(contact_attributes)
    end

    # used for ensuring the values of the attributes hashes are strings
    def self.values_to_string(hash)
      hash.each{ |key, value| hash[key] = value.to_s }
    end

  end
end
