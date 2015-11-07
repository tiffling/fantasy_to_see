class PlayerPresenter
  attr_reader :owner_team

  def initialize(hsh, owner_team)
    @hsh = hsh
    @owner_team = owner_team
  end

  def full_name
    name['full']
  end

  def shortened_name
    if position == 'DEF'
      full_name
    else
      "#{name['first'][0]}. #{name['last']}"
    end
  end

  def team
    hsh['editorial_team_abbr']
  end

  def position
    hsh['display_position']
  end

  def selected_position
    hsh['selected_position']['position']
  end

  def image
    hsh['headshot']['url']
  end

  def starting?
    hsh['selected_position']['position'] != 'BN'
  end

  def benched?
    !starting?
  end

  def uniform_number
    return '' if position == 'DEF'
    "##{hsh['uniform_number']}"
  end

  def matchup_player_blurb
    "#{uniform_number} #{full_name} #{position}-#{team}".strip
  end

  private

  attr_reader :hsh

  def name
    hsh['name']
  end
end
