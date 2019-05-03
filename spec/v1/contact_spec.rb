require 'spec_helper'

describe Promoter::Contact do

  it 'returns all contacts paginated' do
    stub_request(:get, "https://app.promoter.io/api/contacts/?page=2").
         to_return(status: 200, body: fixture('contacts.json'))
    result = Promoter::Contact.all(page: 2)

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Contact)
  end

  it 'filters for an email' do
    url = "https://app.promoter.io/api/contacts/?email=chris@lexoo.co.uk&page=1"
    stub_request(:get, url).
         to_return(status: 200, body: fixture('contacts.json'))
    result = Promoter::Contact.all(email: 'chris@lexoo.co.uk')

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Contact)
  end

  it 'returns all contacts paginated (deprecated style)' do
    stub_request(:get, "https://app.promoter.io/api/contacts/?page=2").
         to_return(status: 200, body: fixture('contacts.json'))
    result = Promoter::Contact.all(2)

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Contact)
  end

  it 'surveys a contact' do
    stub_request(:post, "https://app.promoter.io/api/contacts/survey/").
         to_return(status: 200, body: fixture('survey_a_contact.json'))

    contact = Promoter::Contact.survey(campaign: 99, email: "kate@mac.com", first_name: "Kate", last_name: "Bell", attributes: {"plan": "bronze"})

    expect(Promoter::Contact).to eq(contact.class)

    # Check that the fields are accessible by our model
    expect(contact.email).to eq('kate@mac.com')
    expect(contact.first_name).to eq('Kate')
    expect(contact.last_name).to eq("Bell")
    expect(contact.attributes).to eq({ 'plan' => 'bronze' })
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

  it 'users string values for contact attributes' do
    expected_params = {
      email: 'chris@lexoo.co.uk',
      attributes: {
        starred: 'true'
      }
    }

    stub_request(:post, "https://app.promoter.io/api/contacts/").
        with(body: expected_params.to_json).
        to_return(status: 200, body: fixture('single_contact.json'))

    attributes = {
      starred: true
    }
    Promoter::Contact.create(email: "chris@lexoo.co.uk",
                             attributes: attributes)
  end

  it 'deletes a contact' do
    stub_request(:get, "https://app.promoter.io/api/contacts/3162232").
         to_return(status: 200, body: fixture('single_contact.json'))

    stub_request(:post, "https://app.promoter.io/api/contacts/remove/").
         to_return(status: 200, body: fixture('delete_contact.json'))

    test_id = 3162232
    contact = Promoter::Contact.find(test_id)

    expect(Promoter::Contact).to eq(contact.class)

    deleted = contact.destroy
    expect(deleted.email).to eq(nil)
    expect(deleted.first_name).to eq(nil)
    expect(deleted.last_name).to eq(nil)
  end

end
