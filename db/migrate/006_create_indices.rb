class CreateIndices < ActiveRecord::Migration
  def self.up
    add_index :harbors, :project_id
    add_index :shipped_targets, :harbor_id
    add_index :shipped_targets, :issue_id
    add_index :shipped_changes, :changeset_id
    add_index :shipped_changes, :harbor_id
  end

  def self.down
  end
end
