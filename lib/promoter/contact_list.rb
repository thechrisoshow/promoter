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
      Request.delete("#{API_URL}/#{contact_list_id}/contacts/#{contact_id}")
    end

  end
end