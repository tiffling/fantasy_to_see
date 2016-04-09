require 'spec_helper'

describe League do
  describe '#update_from_api' do
    it 'updates league info from yahoo' do
      data = {
        'query' => {
          'results' => {
            'league' => {
                'team_info' => 'foobar'
            }
          }
        }
      }

      fake_token = double(query_league: data)
      league = create(:league)
      league.update_from_api(fake_token)
      expect(league.reload.data).to eq data['query']['results']['league']
    end
  end
end
