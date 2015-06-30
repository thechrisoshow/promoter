require 'spec_helper'

describe Promoter::Campaign do

  it 'returns all campaigns' do
    stub_request(:get, "https://app.promoter.io/api/campaigns/?page=1").
         to_return(status: 200, body: fixture('campaigns.json'))
    result = Promoter::Campaign.all

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

  it 'sends surveys' do
    stub_request(:post, "https://app.promoter.io/api/campaigns/77/send-surveys").
         with(body: {all_contacts: false}.to_json).
         to_return(status: 200, body: ["surveys sent"].to_json)

    result = Promoter::Campaign.send_surveys(77)
    expect(result).to be_truthy
  end

  it 'sends surveys to all contacts' do
    stub_request(:post, "https://app.promoter.io/api/campaigns/77/send-surveys").
         with(body: {all_contacts: true}.to_json).
         to_return(status: 200, body: ["surveys sent"].to_json)

    result = Promoter::Campaign.send_surveys(77, true)
    expect(result).to be_truthy
  end

end