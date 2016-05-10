class CreateCustomFields < ActiveRecord::Migration
  def self.up
    custom_field = CustomField.create!({
      name: WillShip::CUSTOM_FIELD_SHIPPED,
      field_format: 'bool',
      is_required: false,
      is_for_all: true,
      default_value: 0,
      is_filter: true,
      searchable: true,
      editable: true,
      visible: false,
      format_store: {
        url_pattern: '',
        edit_tag_style: 'check_box'
      }
    })
    CustomField.last.update_column(:type, "IssueCustomField")
  end

  def self.down
    # nope
  end
end
