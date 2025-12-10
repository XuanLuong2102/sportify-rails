class SportfieldSerializer < BaseSerializer
  attributes :sportfield_id, :name, :description

  has_many :place_sports

  def name
    I18n.locale == :vi ? object.name_vi : object.name_en
  end

  def description
    I18n.locale == :vi ? object.description_vi : object.description_en
  end
end
