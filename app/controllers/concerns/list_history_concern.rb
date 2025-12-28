module ListHistoryConcern
  extend ActiveSupport::Concern

  included do
    before_action :store_current_list_path, only: %i[index deleted]
  end

  private

  def store_current_list_path
    session[list_history_key] = request.fullpath
  end

  def last_list_path
    session[list_history_key]
  end

  def list_history_key
    "#{controller_name}_return_path"
  end
end