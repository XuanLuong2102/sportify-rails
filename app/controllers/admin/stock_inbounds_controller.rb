module Admin
  class StockInboundsController < Admin::AdminController
    include PaginatableConcern

    before_action :set_stock_inbound, only: [:show]

    def index
      @q = StockInbound.ransack(params[:q])
      stock_inbounds = @q.result(distinct: true)
                         .includes(:warehouse, :supplier, product_variant: [:product, :product_color, :product_size])
                         .order(received_at: :desc)
      
      # Group by batch_number
      grouped_inbounds = stock_inbounds.group_by(&:batch_number)
                                       .sort_by { |batch, items| items.first.received_at }
                                       .reverse
      
      # Paginate batches using WillPaginate
      per_page = (params[:per_page] || 10).to_i
      page = (params[:page] || 1).to_i
      
      @batches = WillPaginate::Collection.create(page, per_page, grouped_inbounds.size) do |pager|
        start_index = (page - 1) * per_page
        end_index = start_index + per_page - 1
        pager.replace(grouped_inbounds[start_index..end_index] || [])
      end
    end

    def new
      @stock_inbound = StockInbound.new
      @warehouses = Warehouse.all
      @suppliers = Supplier.active
      @products = Product.active.includes(:product_brand, :category)
    end

    def create
      batch_number = "BATCH-#{Time.current.strftime('%Y%m%d%H%M%S')}-#{SecureRandom.hex(3)}"
      warehouse_id = params[:stock_inbound][:warehouse_id]
      supplier_id = params[:stock_inbound][:supplier_id]
      received_at = params[:stock_inbound][:received_at]
      reference_code = params[:stock_inbound][:reference_code]
      
      items = params[:stock_inbound][:items] || []
      errors = []
      created_count = 0
      
      items.each do |item|
        next if item[:product_variant_id].blank? || item[:quantity].blank?
        
        stock_inbound = StockInbound.new(
          warehouse_id: warehouse_id,
          supplier_id: supplier_id,
          received_at: received_at,
          reference_code: reference_code,
          batch_number: batch_number,
          product_variant_id: item[:product_variant_id],
          quantity: item[:quantity],
          cost_price_vnd: item[:cost_price_vnd],
          cost_price_usd: item[:cost_price_usd]
        )
        
        if stock_inbound.save
          update_warehouse_stock(stock_inbound)
          created_count += 1
        else
          errors << "Row #{created_count + 1}: #{stock_inbound.errors.full_messages.join(', ')}"
        end
      end
      
      if errors.empty? && created_count > 0
        flash[:notice] = "Successfully created #{created_count} stock inbound record(s)"
        redirect_to admin_stock_inbounds_path
      else
        @warehouses = Warehouse.all
        @suppliers = Supplier.active
        @products = Product.active.includes(:product_brand, :category)
        flash.now[:alert] = errors.any? ? errors.join('<br>').html_safe : 'No items to create'
        render :new, status: :unprocessable_entity
      end
    end

    def show
    end

    def get_product_variants
      product_id = params[:product_id]
      variants = ProductVariant.where(product_id: product_id)
                               .includes(:product_color, :product_size)
                               .map do |v|
        {
          id: v.id,
          name: "#{v.product_color&.name || 'N/A'} - #{v.product_size&.name || 'N/A'}",
          sku: v.sku,
          price: v.price_vnd
        }
      end
      
      render json: variants
    end

    private

    def set_stock_inbound
      @stock_inbound = StockInbound.includes(:warehouse, :supplier, product_variant: [:product, :product_color, :product_size])
                                   .find(params[:id])
    end

    def stock_inbound_params
      params.require(:stock_inbound).permit(
        :warehouse_id, :supplier_id, :product_variant_id, :quantity,
        :received_at, :reference_code, :cost_price_usd, :cost_price_vnd
      )
    end

    def update_warehouse_stock(stock_inbound)
      warehouse_stock = WarehouseStock.find_or_create_by(
        warehouse_id: stock_inbound.warehouse_id,
        product_variant_id: stock_inbound.product_variant_id
      ) do |stock|
        stock.quantity = 0
      end
      
      warehouse_stock.update!(
        quantity: warehouse_stock.quantity + stock_inbound.quantity
      )
    end
  end
end
