# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :shop, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
