module Promoter

  class ContactList

    attr_reader :id, :name

    API_URL =  "https://app.promoter.io/api/lists"

    def initialize(attrs)
      @id = attrs['id']
      @name = attrs['name']
    end

    def self.all(page=1)
      response = Request.get("#{API_URL}/?page=#{page}")
      response['results'].map {|attrs| new(attrs)}
    end

    def self.contact_ids_for(contact_list_id)
      response = Request.get("#{API_URL}/#{contact_list_id}/contacts")
      response['results'].map {|attrs| attrs["id"]}
    end

    def self.remove_contact(params={})
      contact_list_id = params[:contact_list_id]
      contact_id = params[:contact_id]
      contact_email = params[:email]

      if contact_list_id
        if contact_id
          Request.delete("#{API_URL}/#{contact_list_id}/contacts/#{contact_id}")
        elsif contact_email
          Request.post("#{API_URL}/#{contact_list_id}/remove/", {email: contact_email})
        else
          raise "Not enough information provided to remove a contact"
        end
      elsif contact_email
          Request.post("#{API_URL}/remove/", {email: contact_email})
      else
        raise "Not enough information provided to remove a contact"
      end
    end

    # Campaign Params
    # Parameter                   Optional?  Description
    # name                        no         The name of the campaign
    def self.create(attributes)
      response = Request.post(API_URL + "/", attributes)
      new(response)
    end

  end
end