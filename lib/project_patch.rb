require_dependency 'issue'

module ProjectPatch
  def self.included(klass)
    klass.class_eval do
      unloadable
      has_many :harbors, dependent: :destroy
    end
  end
end
