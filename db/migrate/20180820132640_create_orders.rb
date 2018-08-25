# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :shop, foreign_key: true
      t.references :seller, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
