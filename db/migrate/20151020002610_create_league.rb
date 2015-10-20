class CreateLeague < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :league_key
      t.string :name
      t.json :data
      t.timestamps
    end

    add_column :teams, :league_id, :integer
  end
end
