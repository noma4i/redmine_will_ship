require_dependency 'issue'

module IssuePatch
  def self.included(klass)
    klass.class_eval do
      unloadable
      has_many :shipped_targets, dependent: :destroy
      after_update :check_harbors!

      def check_harbors!
        project = self.project
        harbors = project.harbors
        issue_commits = self.changesets.map(&:scmid)
        is_shipped = false
        empty_harbors = []

        self.changesets.each do |ch|
          ch.shipped_changes.destroy_all
        end

        harbors.each do |h|
          h_t = self.shipped_targets.find_by_harbor_id(h.id) || h.shipped_targets.new(issue_id: self.id)
          harbor_commits = HTTParty.get(h.url).split("\n") rescue []
          empty_harbors << [h.name, h.url] if harbor_commits.empty?
          if check_rules(issue_commits, harbor_commits, h)
            h_t.shipped = true
            is_shipped = true
          else
            h_t.shipped = false
          end
          h_t.save!
          h_t.touch
        end
        cf_id = CustomField.find_by_name(WillShip::CUSTOM_FIELD_SHIPPED).id
        cf = CustomValue.joins(:custom_field).where(custom_fields: {id: cf_id}, customized_id: self.id).first
        if cf.present?
          cf.update_column(:value, is_shipped)
        else
          CustomValue.create!(
            customized_type: 'Issue',
            custom_field_id: cf_id,
            customized_id: self.id,
            value: is_shipped
          )
        end
        if empty_harbors.any?
          empty_harbors
        else
          true
        end
      end

      protected

      def mark_changeset(scmid, harbor_id, shipped)
        ch_set = Changeset.find_by_scmid scmid
        ch_set.shipped_changes.create(harbor_id: harbor_id, shipped: shipped)
      end

      def check_rules(i, h, harbor)
        rule = harbor.lookup_rule

        i.each do |c|
          mark_changeset(c, harbor.id, h.include?(c))
        end

        case rule
          when 'one'
            result = (i & h).any?
          when 'all'
            result = !(i - h).any?
        end

        result
      end
    end
  end
end
