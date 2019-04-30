class CreateAdmin < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :sso_id
      t.string :status
      t.string :roles

      t.timestamps null: false
    end
  end
end
