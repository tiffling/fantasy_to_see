class CreateTeam < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team_key, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.json :data
      t.timestamps
    end
  end
end
