class AddRules < ActiveRecord::Migration
  def self.up
    add_column :harbors, :lookup_rule, :string
  end
end
