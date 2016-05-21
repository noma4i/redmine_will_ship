class AddCustomFieldId < ActiveRecord::Migration
  def self.up
    add_column :harbors, :custom_field_id, :integer
  end

  def self.down
  end
end
