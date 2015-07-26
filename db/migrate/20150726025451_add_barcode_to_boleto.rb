class AddBarcodeToBoleto < ActiveRecord::Migration
  def change
    add_column :boletos, :barcode, :string
  end
end
