class CreateHarbors < ActiveRecord::Migration
  def self.up
    create_table :harbors do |t|
      t.column :project_id, :integer
      t.column :name, :string
      t.column :url, :string
    end
  end

  def self.down
    drop_table :harbors
  end
end
