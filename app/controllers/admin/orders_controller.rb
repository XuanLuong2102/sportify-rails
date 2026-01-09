module Admin
  class OrdersController < Admin::AdminController
    include PaginatableConcern

    def index
      @q = Order.ransack(params[:q])
      @orders = @q.result(distinct: true)
                  .includes(:user, :place, :order_items, :payments)
                  .order(created_at: :desc)
                  .paginate(page: params[:page], per_page: params[:per_page])
    end

    def show
      @order = Order.includes(:user, :place, order_items: [:product, :product_variant], payments: [])
                    .find(params[:id])
    end
  end
end
