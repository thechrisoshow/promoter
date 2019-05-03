require 'spec_helper'

describe Promoter::EmailTemplate do

  it 'returns all email templates' do
    stub_request(:get, "https://app.promoter.io/api/email/?page=1").
         to_return(status: 200, body: fixture('email_templates.json'))
    result = Promoter::EmailTemplate.all

    expect(result.count).to eq(1)

    expect(result.class).to eq(Array)
    expect(result[0].class).to eq(Promoter::EmailTemplate)

    first_result = result.first
    expect(first_result.id).to eq(1)
    expect(first_result.name).to eq("My Email Template")
    expect(first_result.logo).to eq("My Logo")
    expect(first_result.subject).to eq("Take 60 seconds to answer this survey")
    expect(first_result.reply_to_email).to eq("feedback@company.com")
    expect(first_result.from_name).to eq("John Doe")
    expect(first_result.language).to eq("en")
    expect(first_result.company_brand_product_name).to eq("Pear Computers")
  end

  it 'creates an email template' do
    params = { name: 'New Email Template' }

    stub_request(:post, "https://app.promoter.io/api/email/").
        with(body: params.to_json).
        to_return(status: 200, body: fixture('single_email_templates.json'))

    email_template = Promoter::EmailTemplate.create(name: "New Email Template")
    expect(email_template.class).to eq(Promoter::EmailTemplate)
    expect(email_template.name).to eq("New Email Template")
  end
end
