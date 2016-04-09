require 'spec_helper'

describe MatchupFilter do
  describe '#matchup_presenters' do
    let!(:my_team_teams){ ['Jax', 'PAT', 'IND'] }
    let!(:opposing_team_teams){ ['SF', 'CAR', 'MIA'] }

    it 'returns all matchup presenters associated to the given week and teams' do
      fake_fetcher = double(matchups: [
          { 'team' => [ { 'id' => 'PAT' }, { 'id' => 'Jax' } ] },
          { 'team' => [ { 'id' => 'SF' }, { 'id' => 'TBB' } ] },
          { 'team' => [ { 'id' => 'CAR'}, { 'id' => 'PIT' } ] },
          { 'team' => [ { 'id' => 'JAC'}, { 'id' => 'NOS' } ] }
      ])
      allow(ScheduleFetcher).to receive(:new).and_return(fake_fetcher)
      allow(MatchupPresenter).to receive(:new)
      filter = MatchupFilter.new('1', my_team_teams + opposing_team_teams, nil)
      expect(filter.matchup_presenters.count).to eq 3
      allow(MatchupPresenter).to receive(:new).with({ 'team' => [ { 'id' => 'PAT' }, { 'id' => 'Jax' } ] }, 'Eastern Time (US & Canada)')
      allow(MatchupPresenter).to receive(:new).with({ 'team' => [ { 'id' => 'SF' }, { 'id' => 'TBB' } ] }, 'Eastern Time (US & Canada)')
      allow(MatchupPresenter).to receive(:new).with({ 'team' => [ { 'id' => 'CAR' }, { 'id' => 'PIT' } ] }, 'Eastern Time (US & Canada)')
    end
  end
end
