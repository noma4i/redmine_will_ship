class Harbor < ActiveRecord::Base
  unloadable

  belongs_to :project
  has_many :shipped_targets, dependent: :destroy
  has_many :shipped_changes, dependent: :destroy
end
