class ShippedChange < ActiveRecord::Base
  unloadable

  belongs_to :harbor
  belongs_to :changeset
end
