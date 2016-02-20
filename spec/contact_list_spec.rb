require 'spec_helper'

describe Promoter::ContactList do

  it 'returns all contact lists' do
    stub_request(:get, "https://app.promoter.io/api/lists/?page=1").
         to_return(status: 200, body: fixture('contact_lists.json'))
    result = Promoter::ContactList.all

    expect(result.count).to eq(1)
    expect(result.class).to eq(Array)

    first_result = result[0]
    expect(first_result.class).to eq(Promoter::ContactList)
    expect(first_result.id).to eq(1)
    expect(first_result.name).to eq("My Contact List")
  end

  it 'returns all contacts for the contact list' do
    stub_request(:get, "https://app.promoter.io/api/lists/1/contacts").
         to_return(status: 200, body: fixture('contact_list_contact_ids.json'))

    contact_list = Promoter::ContactList.contact_ids_for(1)
    expect(contact_list).to eq([100000])
  end

  it 'removes a contact from a contact list' do
    stub_request(:delete, "https://app.promoter.io/api/lists/23/contacts/77").
         to_return(status: 200, body: {result: true}.to_json)

    response = Promoter::ContactList.remove_contact(contact_list_id: 23,
                                                  contact_id: 77)
    expect(response["result"]).to be_truthy
  end

  it 'creates a contact list' do
    params = { name: 'My Contact List' }

    stub_request(:post, "https://app.promoter.io/api/lists/").
        with(body: params.to_json).
        to_return(status: 200, body: fixture('single_contact_list.json'))

    contact_list = Promoter::ContactList.create(name: "My Contact List")
    expect(contact_list.class).to eq(Promoter::ContactList)
    expect(contact_list.name).to eq("My Contact List")
  end

  it 'removes a contact from list by email' do
    stub_request(:post, "https://app.promoter.io/api/lists/23/remove/").
         to_return(status: 200, body: fixture('single_contact.json'))

    response = Promoter::ContactList.remove_contact(contact_list_id: 23,
                                                  email: "kate@mac.com")
    expect(response["result"]).to eq(nil)
  end

  it 'removes a contact from all lists' do
    stub_request(:post, "https://app.promoter.io/api/lists/remove/").
         to_return(status: 200, body: fixture('delete_contact.json'))

    response = Promoter::ContactList.remove_contact(email: "kate@mac.com")

    expect(response["count"]).to eq(0)
  end

end