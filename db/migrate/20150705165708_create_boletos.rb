class CreateBoletos < ActiveRecord::Migration
  def change
    create_table :boletos do |t|
      t.references :user, index: true
      t.date :due_date
      t.string :hash_url

      t.timestamps null: false
    end
    add_foreign_key :boletos, :users
  end
end
