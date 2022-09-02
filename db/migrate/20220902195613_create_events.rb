class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.string :address
      t.datetime :datetime, default: Time.now + (24 * 3600)

      t.timestamps
    end
  end
end
