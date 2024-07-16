class AddSeedToUsers < ActiveRecord::Migration[6.1]
    def change
      add_column :users, :seed, :boolean, default: false
    end
end