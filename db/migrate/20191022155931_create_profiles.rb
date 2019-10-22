class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :person_id
      t.string :stuff

      t.timestamps
    end
  end
end
