module WillShip
  CUSTOM_FIELD_SHIPPED = 'Shipped'
  LOOKUP_RULES = {
    'All commits should present' => 'all',
    'At least ONE commit is present' => 'one'
  }
    class << self

    def custom_fields_list
      [
        CUSTOM_FIELD_SHIPPED
      ]
    end

    def missing_custom_fields
      fields = [
        CustomField.where(name: CUSTOM_FIELD_SHIPPED).any?
      ]

      fields.include?(false) ? true : false
    end
  end
end
