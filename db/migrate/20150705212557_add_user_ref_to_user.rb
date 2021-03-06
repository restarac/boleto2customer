class AddUserRefToUser < ActiveRecord::Migration
  def change
    add_reference :users, :sender_user, references: :users, index: true
    add_foreign_key :users, :users, column: :sender_user_id
  end
end
