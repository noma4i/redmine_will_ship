require_dependency 'issue'
require 'open-uri'

module IssuePatch
  def self.included(klass)
    klass.class_eval do
      unloadable
      has_many :shipped_targets, dependent: :destroy
      after_update :check_harbors!

      def check_harbors!
        project = self.project
        harbors = project.harbors
        issue_commits = self.changesets.map(&:revision)
        harbors.each do |h|
          h_t = self.shipped_targets.find_by_harbor_id(h.id) || h.shipped_targets.new(issue_id: self.id)
          harbor_commits = open(h.url).read.split("\n") rescue []
          if (issue_commits - harbor_commits).any?
            h_t.shipped = false
          else
            h_t.shipped = true
          end
          h_t.save
        end
      end
    end
  end
end
