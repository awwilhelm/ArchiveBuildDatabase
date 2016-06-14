class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :build_id
      t.string :simple_build_id
      t.integer :int_build_id
      t.boolean :windows32
      t.boolean :windows64
      t.boolean :mac_universal
      t.text :release_notes
      t.text :filepath
      t.datetime :time

      t.timestamps null: false
    end
  end
end
