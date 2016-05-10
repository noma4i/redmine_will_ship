class Harbor < ActiveRecord::Base
  unloadable

  belongs_to :project
  has_many :shipped_targets
end
