class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :slug
      t.string :password_digest

      t.timestamps
    end

    add_index :users, :slug, unique: true
  end
end
