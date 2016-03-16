class AddIndexToPasswordResetTokenOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :password_reset_token
  end
end
