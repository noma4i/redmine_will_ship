class CreateTargets < ActiveRecord::Migration
  def self.up
    create_table :shipped_targets do |t|
      t.column :harbor_id, :integer
      t.column :issue_id, :integer
      t.column :shipped, :boolean
      t.column :shipped, :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :shipped_targets
  end
end
