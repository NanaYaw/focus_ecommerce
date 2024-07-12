class CreateProductLines < ActiveRecord::Migration[7.1]
  def change
    create_table :product_lines do |t|
      t.references :product, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.integer :quantity

      t.timestamps
    end
  end
end
