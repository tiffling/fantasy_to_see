FactoryGirl.define do
  factory :league do
    sequence(:league_key){ |n| "league_key_#{n}" }
    sequence(:name){ |n| "League #{n}" }
    data "{}"
  end

  factory :team do
    sequence(:team_key){ |n| "team_key_#{n}" }
    sequence(:name){ |n| "My Team #{n}" }
    sequence(:url){ |n| "http://foo.com/f1/1/#{n}" }
    league
    data "{}"
  end
end
