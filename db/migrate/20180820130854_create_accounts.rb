# frozen_string_literal: true

class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts, &:timestamps
  end
end
