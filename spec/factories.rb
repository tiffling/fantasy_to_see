FactoryGirl.define do
  factory :league do
    sequence(:league_key){ |n| "league_key_#{n}" }
    sequence(:name){ |n| "League #{n}" }
    data do
      {
        'scoreboard' => {
          'matchups' => {
            'matchup' => []
          }
        }
      }
    end
  end

  factory :team do
    sequence(:team_key){ |n| "team_key_#{n}" }
    sequence(:name){ |n| "My Team #{n}" }
    sequence(:url){ |n| "http://foo.com/f1/1/#{n}" }
    league
    data do
      {
        'team_logos' => {
          'team_logo' => {
            'url' => 'foobar.com'
          }
        },
        'roster' => {
          'week' => '1',
          'players' => {
            'player' => [
              'name' => {
                'full' => 'Matthew Stafford',
                'first' => 'Matthew',
                'last' => 'Stafford'
              },
              'editorial_team_abbr' => 'Det',
              'uniform_number' => '9',
              'selected_position' => {
                'position' => 'DEF'
              },
              'headshot' => {
                'url' => 'foo.png',
                'size' => 'small'
              }
            ]
          }
        }
      }
    end
  end
end
