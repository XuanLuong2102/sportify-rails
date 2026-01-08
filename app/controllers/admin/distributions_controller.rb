module Admin
  class DistributionsController < Admin::AdminController
    include PaginatableConcern

    before_action :set_stock_request, only: [:approve, :reject]
    
    def index
      # Get all stock transfers and group by stock_request_id
      stock_transfers_all = StockTransfer.includes(
        :place, :stock_request, :product_variant, :transferred_by, :warehouse
      ).order(transferred_at: :desc)
      
      # Group by stock_request_id
      @grouped_stock_transfers = stock_transfers_all.group_by(&:stock_request_id)
      
      @stock_requests = StockRequest.includes(
        :place, :requester, :approver, :stock_request_items
      ).order(created_at: :desc).paginate(page: params[:page], per_page: params[:per_page])
      
      @tab = params[:tab] || 'transfers'
    end

    def approve
      @stock_request_items = @stock_request.stock_request_items.includes(:product_variant)
      
      respond_to do |format|
        if @stock_request.update(status: :approved, approved_by_id: current_user.user_id, approved_at: Time.current)
          # Create stock transfers and update product_stocks for each item in the request
          @stock_request_items.each do |item|
            stock_transfer = StockTransfer.create(
              stock_request_id: @stock_request.id,
              place_id: @stock_request.place_id,
              warehouse_id: params[:warehouse_id] || Warehouse.first&.id,
              product_variant_id: item.product_variant_id,
              quantity: item.requested_quantity,
              transferred_by_id: current_user.user_id,
              transferred_at: Time.current,
              note: params[:note]
            )
            
            # Update product stock after creating stock transfer
            update_product_stock(item, stock_transfer)
          end
          
          format.json { render json: { status: 'success', message: 'Request approved and stock transferred successfully' }, status: :ok }
          format.html { redirect_to admin_distributions_path(tab: 'requests'), notice: 'Request approved successfully' }
        else
          format.json { render json: { status: 'error', message: @stock_request.errors.full_messages }, status: :unprocessable_entity }
          format.html { redirect_to admin_distributions_path(tab: 'requests'), alert: 'Error approving request' }
        end
      end
    end

    def reject
      respond_to do |format|
        if @stock_request.update(status: :rejected, approved_by_id: current_user.user_id, rejected_at: Time.current)
          format.json { render json: { status: 'success', message: 'Request rejected successfully' }, status: :ok }
          format.html { redirect_to admin_distributions_path(tab: 'requests'), notice: 'Request rejected successfully' }
        else
          format.json { render json: { status: 'error', message: @stock_request.errors.full_messages }, status: :unprocessable_entity }
          format.html { redirect_to admin_distributions_path(tab: 'requests'), alert: 'Error rejecting request' }
        end
      end
    end

    private

    def set_stock_request
      @stock_request = StockRequest.find(params[:id])
    end

    def update_product_stock(stock_request_item, stock_transfer)
      # Get the product variant to find the product
      product_variant = stock_request_item.product_variant
      product = product_variant.product
      
      # Find product listing for the destination place
      product_listing = ProductListing.find_by(
        place_id: stock_transfer.place_id,
        product_id: product.id
      )
      
      # If product listing exists, update or create product stock
      if product_listing
        product_stock = ProductStock.find_or_create_by(
          product_listing_id: product_listing.id,
          product_variant_id: stock_request_item.product_variant_id
        )
        
        # Increase stock quantity
        product_stock.update(
          stock_quantity: product_stock.stock_quantity + stock_transfer.quantity
        )
      end
    end
  end
end
