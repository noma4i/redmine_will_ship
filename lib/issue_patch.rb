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

          cf = h.custom_field
          if cf.present?
            cf_shipped_value = cast_value(cf, is_shipped)
            cf_value = CustomValue.joins(:custom_field).where(custom_fields: {id: cf.id}, customized_id: self.id).first
            if cf_value.present?
              cf_value.update_column(:value, cf_shipped_value)
            else
              CustomValue.create!(
                customized_type: 'Issue',
                custom_field_id: cf.id,
                customized_id: self.id,
                value: cf_shipped_value
              )
            end
          end
        end

        if empty_harbors.any?
          empty_harbors
        else
          true
        end
      end

      protected

      def cast_value(custom_field, value)
        case custom_field.field_format
        when 'int'
          value ? 1 : 0
        when 'bool'
          value
        when 'string', 'text'
          value ? 'Yes' : 'No'
        end
      end

      def mark_changeset(scmid, harbor_id, shipped)
        ch_set = Changeset.find_by_scmid scmid

        return unless ch_set.present?

        shipped_changes = ShippedChange.where(changeset_id: ch_set.id, harbor_id: harbor_id)

        if shipped_changes.size > 1
          shipped_changes.map(&:delete)
          sets = ch_set.shipped_changes.new(harbor_id: harbor_id)
        else
          sets = shipped_changes.try(:first) || ch_set.shipped_changes.new(harbor_id: harbor_id)
        end

        sets.shipped = shipped
        sets.save!
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

        i.any? ? result : false
      end
    end
  end
end
