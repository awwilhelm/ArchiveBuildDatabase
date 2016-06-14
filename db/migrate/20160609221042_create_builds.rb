class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :build_id
      t.boolean :windows32
      t.boolean :windows64
      t.boolean :mac
      t.boolean :mac64
      t.boolean :mac_universal
      t.text :filepath
      t.datetime :time

      t.timestamps null: false
    end
  end
end
