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
        is_shipped = false
        harbors.each do |h|
          h_t = self.shipped_targets.find_by_harbor_id(h.id) || h.shipped_targets.new(issue_id: self.id)
          harbor_commits = open(h.url).read.split("\n") rescue []
          if check_rules(issue_commits, harbor_commits, h.lookup_rule)
            h_t.shipped = true
            is_shipped = false
          else
            h_t.shipped = false
          end
          h_t.save
        end
        shipped_cf = CustomValue.joins(:custom_field).where(custom_fields: {id: custom_field_pivotal_story_description}, customized_id: issue_id).first
        shipped_cf.update_column(:value, is_shipped)
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
