require "spec_helper"

describe Promoter::Contact do

  before(:each) do
    Promoter.api_version = 2;
  end

  it "surveys a contact" do
    stub_request(:post, "https://app.promoter.io/api/v2/survey/").
         to_return(status: 200, body: fixture("survey_a_contact.json"))

    contact = Promoter::Contact.survey(campaign: 99,
                                       email: "chris@mac.com",
                                       first_name: "Chris",
                                       last_name: "O'Sullivan",
                                       attributes: { "customer_id": "7" },
                                       survey_attributes: {
                                         product: "Box of apples"
                                      })

    expect(Promoter::Contact).to eq(contact.class)

    # Check that the fields are accessible by our model
    expect(contact.email).to eq("chris@mac.com")
    expect(contact.first_name).to eq("Chris")
    expect(contact.last_name).to eq("O'Sullivan")
    expect(contact.attributes).to eq({ "customer_id" => "7" })
  end
end
