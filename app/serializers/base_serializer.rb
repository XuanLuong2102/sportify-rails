class BaseSerializer < ActiveModel::Serializer
  def attributes(requested_attrs = nil, reload = false)
    @attributes = nil if reload
    default_attrs = self.class._attributes_data.keys.map(&:to_s)

    requested_attrs = requested_attrs.map(&:to_s) if requested_attrs
    final_attrs = requested_attrs.presence || default_attrs

    @attributes ||= serialize_attributes(final_attrs)
  end

  private

  def serialize_attributes(final_attrs)
    self.class._attributes_data.each_with_object({}) do |(key, attr), hash|
      next if attr.excluded?(self)
      next unless final_attrs.include?(key.to_s)

      hash[key] = attr.value(self)
    end
  end
end
