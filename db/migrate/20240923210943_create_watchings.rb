class CreateWatchings < ActiveRecord::Migration[6.0]
  def change
    create_table :watchings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.references :profile, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :finished_at
      t.string :progress, default: 0
      t.integer :status, :default => 0, :null => false

      t.timestamps
    end
  end
end
