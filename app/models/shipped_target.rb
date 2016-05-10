class ShippedTarget < ActiveRecord::Base
  unloadable

  belongs_to :harbor
  belongs_to :issue
end
