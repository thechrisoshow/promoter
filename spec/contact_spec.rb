require 'spec_helper'

describe Promoter::Contact do

  it 'returns all contacts' do
    stub_request(:get, "https://app.promoter.io/api/contacts/?page=1").
         to_return(status: 200, body: fixture('contacts.json'))
    result = Promoter::Contact.all

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Contact)
  end

  it 'returns a single contact' do
    stub_request(:get, "https://app.promoter.io/api/contacts/3162232").
         to_return(status: 200, body: fixture('single_contact.json'))

    test_id = 3162232
    contact = Promoter::Contact.find(test_id)

    expect(Promoter::Contact).to eq(contact.class)

    # Check that the fields are accessible by our model
    expect(contact.id).to eq(test_id)
    expect(contact.email).to eq('chris@lexoo.co.uk')
    expect(contact.first_name).to eq('Chris')
    expect(contact.last_name).to eq("O'Sullivan")
    expect(contact.created_date).to eq(Time.parse("2014-12-09T12:22:57Z"))
    expect(contact.attributes).to eq({ 'position' => 'CTO' })
  end

  it 'creates a contact' do
    params = { email: 'chris@lexoo.co.uk' }

    stub_request(:post, "https://app.promoter.io/api/contacts/").
        with(body: params.to_json).
        to_return(status: 200, body: fixture('single_contact.json'))

    contact = Promoter::Contact.create(email: "chris@lexoo.co.uk")
    expect(contact.class).to eq(Promoter::Contact)
    expect(contact.email).to eq("chris@lexoo.co.uk")
  end

end
