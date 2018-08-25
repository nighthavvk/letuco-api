# frozen_string_literal: true

class CreateJoinTableOrderProduct < ActiveRecord::Migration[5.2]
  def change
    create_join_table :orders, :products do |t|
      t.index %i[order_id product_id]
    end
  end
end
