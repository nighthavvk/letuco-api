# frozen_string_literal: true

class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.references :account, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
