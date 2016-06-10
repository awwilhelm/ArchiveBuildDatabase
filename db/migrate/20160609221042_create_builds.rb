class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :build_id
      t.string :architecture_type
      t.string :zip_type
      t.text :filepath
      t.datetime :time

      t.timestamps null: false
    end
  end
end
