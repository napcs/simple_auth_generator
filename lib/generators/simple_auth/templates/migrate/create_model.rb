class <%= "create_#{table_name}".classify.pluralize %> < ActiveRecord::Migration
  def self.up
    create_table :<%=table_name %> do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :remember_token,              :limit => 40
      t.datetime :remember_token_expires_at
      t.string :activation_code,             :limit => 40
      t.string :activated_at              
      t.string :password_reset_token,         :limit => 40
      t.timestamps
    end
    add_index :<%= table_name %>, :username, :unique => true
  
  end
  

  def self.down
    drop_table :<%=table_name %>
  end
end
