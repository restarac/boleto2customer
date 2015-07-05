class AddSenderEmailOnBoleto < ActiveRecord::Migration
  def change
    add_column :boletos, :sender_origin_email, :string
  end
end
