require 'spec_helper'

describe 'configuration' do

  describe 'api_key' do
    it 'returns default key' do
      expect(Promoter.api_key).to eq('ribeyeeulorem')
    end
  end

end