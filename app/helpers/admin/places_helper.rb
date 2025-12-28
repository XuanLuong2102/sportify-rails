module Admin::PlacesHelper
  def place_status(place)
    if place.is_close
      t('places.status_closed')
    elsif place.maintenance_place
      t('places.status_under_maintenance')
    else
      t('places.status_active')
    end
  end
end