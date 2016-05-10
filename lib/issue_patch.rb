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
          if check_rules(issue_commits, harbor_commits, h.lookup_rule)
            h_t.shipped = true
          else
            h_t.shipped = false
          end
          h_t.save
        end
      end

      protected

      def check_rules(i, h, rule)
        case rule
          when 'one'
            (i & h).any?
          when 'all'
            !(i - h).any?
        end
      end
    end
  end
end
