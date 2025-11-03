module ApiAuthenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api!
  end

  private

  def authenticate_api!
    token = request.headers['Authorization']&.split(' ')&.last
    render json: { error: 'Unauthorized' }, status: :unauthorized and return unless token
    @api_client = ApiClient.find_by(api_key: token)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @api_client
  end
end
