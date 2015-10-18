class CreateTeam < ActiveRecord::Migration
  def change
    enable_extension :hstore

    create_table :teams do |t|
      t.string :team_key, null: false
      t.string :name, null: false
      t.string :url, null: false
      t.hstore :data, default: {}
      t.timestamps
    end
  end
end
