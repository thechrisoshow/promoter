require 'spec_helper'

describe Promoter::Metric do

  it 'returns all metrics' do
    stub_request(:get, "https://app.promoter.io/api/metrics/").
         to_return(status: 204, body: fixture('metrics.json'))
    result = Promoter::Metric.all

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    first_metric = result[0]
    expect(first_metric.class).to eq(Promoter::Metric)
    expect(first_metric.campaign_name).to eq("My Campaign")
    expect(first_metric.nps).to be_within(0.01).of(50.0)
    expect(first_metric.organization_nps).to be_within(0.01).of(35.0)
  end

end