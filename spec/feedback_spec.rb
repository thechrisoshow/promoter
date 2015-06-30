require 'spec_helper'

describe Promoter::Feedback do

  describe 'all' do

    it 'filters by score' do
      url = "https://app.promoter.io/api/feedback/?score=8"
      stub_get_request(url, 'feedback_by_score.json')

      result = Promoter::Feedback.all(score: 8)

      expect(result.count).to eq(1)

      first_result = result[0]
      expect(first_result.class).to eq(Promoter::Feedback)
      expect(first_result.id).to eq(1600)
      expect(first_result.score).to eq(8)
      expect(first_result.score_type).to eq('passive')
      expect(first_result.comment).to eq('Price is great! Service is ok.')
      expect(first_result.posted_date).to eq(Time.parse("2014-12-01T20:00:00Z"))
      contact = first_result.contact
      expect(contact.first_name).to eq("Kate")
    end

    it 'filters by score type' do
      url = "https://app.promoter.io/api/feedback/?score_type=promoter"
      stub_get_request(url, 'feedback_by_score_type.json')

      result = Promoter::Feedback.all(score_type: :promoter)

      expect(result.count).to eq(1)

      first_result = result[0]
      expect(first_result.class).to eq(Promoter::Feedback)
      expect(first_result.id).to eq(270)
      expect(first_result.score).to eq(9)
      expect(first_result.score_type).to eq('promoter')
      expect(first_result.comment).to eq('Amazing product! Love the promo flyers!')
      expect(first_result.posted_date).to eq(Time.parse("2014-12-01T11:00:00Z"))
      contact = first_result.contact
      expect(contact.first_name).to eq("Anna")
    end

    it 'filters by campaign' do
      url = "https://app.promoter.io/api/feedback/?survey_campaign=2"
      stub_get_request(url, 'feedback_by_campaign.json')

      result = Promoter::Feedback.all(campaign_id: 2)

      expect(result.count).to eq(1)

      first_result = result[0]
      expect(first_result.class).to eq(Promoter::Feedback)
      expect(first_result.id).to eq(5200)
      expect(first_result.score).to eq(2)
      expect(first_result.score_type).to eq('detractor')
      expect(first_result.comment).to eq("Website doesn't work. Pricing is expensive.")
      expect(first_result.posted_date).to eq(Time.parse("2014-10-10T8:20:00Z"))
      contact = first_result.contact
      expect(contact.first_name).to eq("Hank")

    end
  end

  describe 'find' do
    it 'returns a single feedback' do
      url = "https://app.promoter.io/api/feedback/270"
      stub_get_request(url, "single_feedback.json")

      result = Promoter::Feedback.find(270)

      expect(result.class).to eq(Promoter::Feedback)
      expect(result.id).to eq(270)
      expect(result.score_type).to eq('promoter')
      expect(result.comment).to eq("Amazing product! Love the promo flyers!")
      expect(result.posted_date).to eq(Time.parse("2014-12-01T11:00:00Z"))
      expect(result.follow_up_url).to eq("https://app.promoter.io/org/50/campaign/101/responses/all/response/1600/")
      contact = result.contact
      expect(contact.class).to eq(Promoter::Contact)
      expect(contact.first_name).to eq("Anna")
    end
  end

end
