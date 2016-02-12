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

    def self.all(page=1)
      response = Request.get("#{API_URL}/?page=#{page}")
      response['results'].map {|attrs| new(attrs)}
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
    def self.create(attributes)
      response = Request.post(API_URL + "/", attributes)
      new(response)
    end

    def self.survey(attributes)
      response = Request.post(API_URL + "/survey/", attributes)
      new(response)
    end

  end
end