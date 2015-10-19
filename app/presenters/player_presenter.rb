class PlayerPresenter
  def initialize(hsh)
    @hsh = hsh
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

  def starting?
    hsh['selected_position']['position'] != 'BN'
  end

  def uniform_number
    hsh['uniform_number']
  end

  private

  attr_reader :hsh

  def name
    hsh['name']
  end
end
