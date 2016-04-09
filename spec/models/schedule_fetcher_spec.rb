require 'spec_helper'

describe ScheduleFetcher do
  describe '#matchups' do
    it 'scraps the xml from the url and returns matchup info as array of hashes' do
      fake_xml = <<-XML
        <nflSchedule>
          <matchup>
            <team id="PAT"/>
            <team id="DAL"/>
          </matchup>

          <matchup>
            <team id="NYJ"/>
            <team id="CLE"/>
          </matchup>
        </nflSchedule>
      XML
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: fake_xml))
      expect(ScheduleFetcher.new('1').matchups).to eq [
        {'team'=>[{'id'=>'PAT'}, {'id'=>'DAL'}]},
        {'team'=>[{'id'=>'NYJ'}, {'id'=>'CLE'}]}
      ]
      expect(Net::HTTP).to have_received(:get_response).with(URI.parse("http://www03.myfantasyleague.com/#{Time.now.year}/export?TYPE=nflSchedule&W=1"))
      end
  end
end
