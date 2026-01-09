class AddBatchNumberToStockInbounds < ActiveRecord::Migration[8.1]
  def change
    add_column :stock_inbounds, :batch_number, :string
    add_index :stock_inbounds, :batch_number
  end
end
