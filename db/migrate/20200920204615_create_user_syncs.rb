# frozen_string_literal: true

class CreateUserSyncs < ActiveRecord::Migration[7.2]
  def change
    create_table :user_syncs do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.integer :current_offset, null: false, default: 0
      t.datetime :completed_at

      t.timestamps
    end
  end
end
