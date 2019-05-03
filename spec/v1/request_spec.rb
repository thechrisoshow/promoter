require 'spec_helper'

describe Promoter::Request do

  it 'raises the right error' do
    url = "https://app.promoter.io/api/contacts"
    stub_request(:get, url).to_return(status: 401)

    expect {
      Promoter::Request.get(url)
    }.to raise_error(Promoter::Errors::Unauthorized)
  end

end