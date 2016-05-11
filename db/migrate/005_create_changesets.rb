class CreateChangesets < ActiveRecord::Migration
  def self.up
    create_table :shipped_changes do |t|
      t.column :changeset_id, :integer
      t.column :harbor_id, :integer
      t.column :shipped, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :shipped_changes
  end
end
