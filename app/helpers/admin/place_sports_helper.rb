module Admin::PlaceSportsHelper
  def badge_status_place_sport(place_sport)
    if place_sport.is_close
      'danger'
    elsif place_sport.maintenance_sport
      'warning'
    else
      'success'
    end
  end

  def place_sport_status(place_sport)
    if place_sport.is_close
      'close'
    elsif place_sport.maintenance_sport
      'under_maintenance'
    else
      'active'
    end
  end
end
