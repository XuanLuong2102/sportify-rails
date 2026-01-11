# frozen_string_literal: true

module Agency
  class StockRequestsController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_stock_request, only: [:show, :cancel]

    def index
      @q = agency_stock_requests.ransack(params[:q])
      @stock_requests = @q.result(distinct: true)
                          .includes(:place, :requester, :approver, :stock_request_items)
                          .order(created_at: :desc)
                          .paginate(page: params[:page], per_page: params[:per_page])
      
      @status_counts = calculate_status_counts
    end

    def pending
      @stock_requests = agency_stock_requests.pending
                                             .includes(:place, :requester, :approver, :stock_request_items)
                                             .order(created_at: :desc)
                                             .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def approved
      @stock_requests = agency_stock_requests.approved
                                             .includes(:place, :requester, :approver, :stock_request_items)
                                             .order(created_at: :desc)
                                             .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def rejected
      @stock_requests = agency_stock_requests.rejected
                                             .includes(:place, :requester, :approver, :stock_request_items)
                                             .order(created_at: :desc)
                                             .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def new
      @stock_request = StockRequest.new
      @stock_request.stock_request_items.build
      @available_places = current_agency_places
    end

    def create
      @stock_request = StockRequest.new(stock_request_params)
      @stock_request.requested_by_id = current_user.user_id
      @stock_request.status = :pending

      # Validate that the place belongs to the agency
      unless current_agency_place_ids.include?(@stock_request.place_id)
        redirect_to new_agency_stock_request_path, alert: I18n.t('agency.stock_requests.invalid_place')
        return
      end

      if @stock_request.save
        redirect_to agency_stock_request_path(@stock_request), 
                    notice: I18n.t('agency.stock_requests.created_successfully')
      else
        @available_places = current_agency_places
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @stock_request = StockRequest.includes(:place, :requester, :approver, 
                                             stock_request_items: [:product, :product_variant])
                                   .find(params[:id])
    end

    def cancel
      if @stock_request.pending? && @stock_request.update(status: :cancelled)
        redirect_to agency_stock_request_path(@stock_request), 
                    notice: I18n.t('agency.stock_requests.cancelled_successfully')
      else
        redirect_to agency_stock_request_path(@stock_request), 
                    alert: I18n.t('agency.stock_requests.cancel_failed')
      end
    end

    private

    def agency_stock_requests
      StockRequest.where(place_id: current_agency_place_ids)
    end

    def set_stock_request
      @stock_request = agency_stock_requests.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_stock_requests_path, alert: I18n.t('agency.stock_requests.not_found')
    end

    def stock_request_params
      params.require(:stock_request).permit(
        :place_id,
        :request_type,
        :notes,
        stock_request_items_attributes: [
          :id,
          :product_id,
          :product_variant_id,
          :quantity,
          :unit_price,
          :notes,
          :_destroy
        ]
      )
    end

    def calculate_status_counts
      {
        pending: agency_stock_requests.pending.count,
        approved: agency_stock_requests.approved.count,
        rejected: agency_stock_requests.rejected.count,
        cancelled: agency_stock_requests.cancelled.count
      }
    end
  end
end
