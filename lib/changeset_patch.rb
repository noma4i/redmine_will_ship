require_dependency 'changeset'

module ChangesetPatch
  def self.included(klass)
    klass.class_eval do
      unloadable
      has_many :shipped_changes, dependent: :destroy
    end
  end
end
