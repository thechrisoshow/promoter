require 'spec_helper'

describe Promoter::Campaign do
  it 'returns all campaigns paginated' do
    stub_request(:get, "https://app.promoter.io/api/campaigns/?page=2").
         to_return(status: 200, body: fixture('campaigns.json'))
    result = Promoter::Campaign.all(page: 2)

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Campaign)

    first_result = result.first
    expect(first_result.id).to eq(1)
    expect(first_result.name).to eq("My Campaign's Name")
    expect(first_result.drip_duration).to eq(7)
    expect(first_result.contact_count).to eq(1)
    expect(first_result.eligible_count).to eq(5)
    expect(first_result.last_surveyed_date).to eq(Time.parse("2014-10-10T12:00:00Z"))
    expect(first_result.launch_date).to eq(nil)
  end

  it 'returns all campaigns paginated (deprecated style)' do
    stub_request(:get, "https://app.promoter.io/api/campaigns/?page=2").
         to_return(status: 200, body: fixture('campaigns.json'))
    result = Promoter::Campaign.all(2)

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::Campaign)
  end

  it 'sends surveys' do
    stub_request(:post, "https://app.promoter.io/api/campaigns/77/send-surveys/").
         with(body: {all_contacts: false}.to_json).
         to_return(status: 200, body: "Success\, surveys sent\.")

    result = Promoter::Campaign.send_surveys(77)
    expect(result).to be_truthy
  end

  it 'sends surveys to all contacts' do
    stub_request(:post, "https://app.promoter.io/api/campaigns/77/send-surveys/").
         with(body: {all_contacts: true}.to_json).
         to_return(status: 200, body: "Success\, surveys sent\.")

    result = Promoter::Campaign.send_surveys(77, true)
    expect(result).to be_truthy
  end

  it 'creates a campaign' do
    params = { name: 'Newest Campaign Name',
               contact_list: 1,
               email: 1 }

    stub_request(:post, "https://app.promoter.io/api/campaigns/").
        with(body: params.to_json).
        to_return(status: 200, body: fixture('single_campaign.json'))

    campaign = Promoter::Campaign.create(name: "Newest Campaign Name",
                                         contact_list: 1,
                                         email: 1)
    expect(campaign.class).to eq(Promoter::Campaign)
    expect(campaign.name).to eq("Newest Campaign Name")
  end

end