class CreateTemps < ActiveRecord::Migration
  def change
    create_table :temps do |t|
      t.string :name
      t.text :url

      t.timestamps null: false
    end
  end
end
