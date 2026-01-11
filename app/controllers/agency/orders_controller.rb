# frozen_string_literal: true

module Agency
  class OrdersController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_order, only: [:show, :update, :confirm, :ship, :complete, :return, :delivery_slip]

    def index
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      
      @status_counts = calculate_status_counts
    end

    def pending
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .where(status: 'pending')
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def confirmed
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .where(status: 'confirmed')
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def shipping
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .where(status: 'shipping')
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def completed
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .where(status: 'completed')
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def returned
      @q = agency_orders.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .where(status: 'returned')
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def show
      @order = Order.includes(:user, :place, order_items: [:product, :product_variant], payments: [])
                    .find(params[:id])
    end

    def confirm
      if @order.update(status: 'confirmed', confirmed_at: Time.current)
        redirect_to agency_order_path(@order), notice: I18n.t('agency.orders.confirmed_successfully')
      else
        redirect_to agency_order_path(@order), alert: I18n.t('agency.orders.confirm_failed')
      end
    end

    def ship
      if @order.update(status: 'shipping', shipped_at: Time.current)
        redirect_to agency_order_path(@order), notice: I18n.t('agency.orders.shipped_successfully')
      else
        redirect_to agency_order_path(@order), alert: I18n.t('agency.orders.ship_failed')
      end
    end

    def complete
      if @order.update(status: 'completed', completed_at: Time.current)
        redirect_to agency_order_path(@order), notice: I18n.t('agency.orders.completed_successfully')
      else
        redirect_to agency_order_path(@order), alert: I18n.t('agency.orders.complete_failed')
      end
    end

    def return
      if @order.update(status: 'returned', returned_at: Time.current)
        redirect_to agency_order_path(@order), notice: I18n.t('agency.orders.returned_successfully')
      else
        redirect_to agency_order_path(@order), alert: I18n.t('agency.orders.return_failed')
      end
    end

    def delivery_slip
      # Render delivery slip for printing
      @order = Order.includes(:user, :place, order_items: [:product, :product_variant])
                    .find(params[:id])
      render layout: 'delivery_slip'
    end

    def update
      if @order.update(order_params)
        redirect_to agency_order_path(@order), notice: I18n.t('agency.orders.updated_successfully')
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def agency_orders
      Order.where(place_id: current_agency_place_ids)
    end

    def set_order
      @order = agency_orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_orders_path, alert: I18n.t('agency.orders.not_found')
    end

    def order_params
      params.require(:order).permit(:status, :notes)
    end

    def calculate_status_counts
      {
        pending: agency_orders.where(status: 'pending').count,
        confirmed: agency_orders.where(status: 'confirmed').count,
        shipping: agency_orders.where(status: 'shipping').count,
        completed: agency_orders.where(status: 'completed').count,
        returned: agency_orders.where(status: 'returned').count
      }
    end
  end
end
