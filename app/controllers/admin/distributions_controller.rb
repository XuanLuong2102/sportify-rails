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
      warehouse_id = params[:warehouse_id] || Warehouse.first&.id
      
      # Validate warehouse stock availability before proceeding
      insufficient_items = []
      @stock_request_items.each do |item|
        warehouse_stock = WarehouseStock.find_by(
          warehouse_id: warehouse_id,
          product_variant_id: item.product_variant_id
        )
        
        if warehouse_stock.nil? || warehouse_stock.quantity < item.requested_quantity
          available_qty = warehouse_stock&.quantity || 0
          insufficient_items << "#{item.product_variant.product.name_en} (Available: #{available_qty}, Requested: #{item.requested_quantity})"
        end
      end
      
      if insufficient_items.any?
        respond_to do |format|
          error_message = "Insufficient warehouse stock for: #{insufficient_items.join(', ')}"
          format.json { render json: { status: 'error', message: error_message }, status: :unprocessable_entity }
          format.html { redirect_to admin_distributions_path(tab: 'requests'), alert: error_message }
        end
        return
      end
      
      respond_to do |format|
        if @stock_request.update(status: :approved, approved_by_id: current_user.user_id, approved_at: Time.current)
          # Create stock transfers and update stocks for each item in the request
          @stock_request_items.each do |item|
            stock_transfer = StockTransfer.create(
              stock_request_id: @stock_request.id,
              place_id: @stock_request.place_id,
              warehouse_id: warehouse_id,
              product_variant_id: item.product_variant_id,
              quantity: item.requested_quantity,
              transferred_by_id: current_user.user_id,
              transferred_at: Time.current,
              note: params[:note]
            )
            
            # Deduct from warehouse stock and add to place stock
            process_stock_transfer(item, stock_transfer, warehouse_id)
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

    def process_stock_transfer(stock_request_item, stock_transfer, warehouse_id)
      # 1. Deduct from warehouse stock
      warehouse_stock = WarehouseStock.find_by(
        warehouse_id: warehouse_id,
        product_variant_id: stock_request_item.product_variant_id
      )
      
      if warehouse_stock
        warehouse_stock.update!(
          quantity: warehouse_stock.quantity - stock_transfer.quantity
        )
      else
        raise "Warehouse stock not found for variant #{stock_request_item.product_variant_id}"
      end
      
      # 2. Add to place stock
      product_variant = stock_request_item.product_variant
      product = product_variant.product
      
      # Find or create product listing for the destination place
      product_listing = ProductListing.find_or_create_by(
        place_id: stock_transfer.place_id,
        product_id: product.id
      ) do |listing|
        listing.is_active = true
        listing.sold_count = 0
      end
      
      # Find or create product stock
      product_stock = ProductStock.find_or_create_by(
        product_listing_id: product_listing.id,
        product_variant_id: stock_request_item.product_variant_id
      ) do |stock|
        stock.stock_quantity = 0
      end
      
      # Increase place stock quantity
      product_stock.update!(
        stock_quantity: product_stock.stock_quantity + stock_transfer.quantity
      )
    end
  end
end
