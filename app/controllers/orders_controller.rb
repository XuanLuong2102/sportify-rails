# frozen_string_literal: true

class OrdersController < ApplicationController
  layout 'user'
  before_action :authenticate_user!, except: [:index]
  before_action :set_order, only: [:show, :confirm, :pay]

  # GET /orders - Product listing page (browse without login)
  def index
    # Get all places that have product listings
    @places = Place.joins(:product_listings)
                   .where(is_close: false)
                   .distinct
    
    @selected_place_id = params[:place_id] || @places.first&.place_id
    
    if @selected_place_id
      # Get products available at selected place
      @products = Product.where(is_active: true)
                         .joins(:product_listings)
                         .where(product_listings: { place_id: @selected_place_id, is_active: true })
                         .includes(:product_brand, :category, 
                                  product_variants: [:product_color, :product_size, :product_stocks])
                         .distinct
      
      # Apply filters
      if params[:color_id].present?
        @products = @products.joins(product_variants: :product_color)
                            .where(product_variants: { product_color_id: params[:color_id] })
      end
      
      if params[:size_id].present?
        @products = @products.joins(product_variants: :product_size)
                            .where(product_variants: { product_size_id: params[:size_id] })
      end
      
      if params[:category_id].present?
        @products = @products.where(category_id: params[:category_id])
      end
      
      # Get available filters
      @colors = ProductColor.joins(product_variants: { product: :product_listings })
                           .where(product_listings: { place_id: @selected_place_id })
                           .distinct
                           .order(:name)
      
      @sizes = ProductSize.joins(product_variants: { product: :product_listings })
                         .where(product_listings: { place_id: @selected_place_id })
                         .distinct
                         .order(:name)
      
      @categories = ProductCategory.joins(products: :product_listings)
                                  .where(product_listings: { place_id: @selected_place_id })
                                  .distinct
                                  .order(:name_en)
    end
    
    # Initialize or get cart from session
    session[:cart] ||= {}
    @cart = session[:cart]
  end

  # POST /orders - Create order from cart
  def create
    # Require authentication for checkout
    unless user_signed_in?
      session[:return_to] = orders_path
      redirect_to new_user_session_path, alert: t('user.orders.login_required')
      return
    end
    
    unless session[:cart]&.any?
      redirect_to orders_path, alert: t('user.orders.cart_empty')
      return
    end
    
    @order = current_user.orders.build(order_params)
    @order.status = 'pending'
    @order.order_code = generate_order_code
    @order.ordered_at = Time.current
    
    # Calculate totals
    subtotal_vnd = 0
    
    session[:cart].each do |variant_id, item|
      variant = ProductVariant.find(variant_id)
      quantity = item['quantity'].to_i
      unit_price_vnd = variant.price_vnd
      
      @order.order_items.build(
        product_id: variant.product_id,
        product_variant_id: variant.id,
        product_name: variant.product.name,
        variant_name: "#{variant.product_color&.name} / #{variant.product_size&.name}",
        quantity: quantity,
        unit_price_vnd: unit_price_vnd,
        unit_price_usd: variant.price_usd || 0,
        total_price_vnd: unit_price_vnd * quantity,
        total_price_usd: (variant.price_usd || 0) * quantity
      )
      
      subtotal_vnd += unit_price_vnd * quantity
    end
    
    shipping_fee_vnd = 30000  # Default 30,000 VND
    @order.subtotal_amount_vnd = subtotal_vnd
    @order.subtotal_amount_usd = 0  # Calculate if needed
    @order.shipping_fee_vnd = shipping_fee_vnd
    @order.shipping_fee_usd = 0
    @order.total_amount_vnd = subtotal_vnd + shipping_fee_vnd
    @order.total_amount_usd = 0
    
    if @order.save
      # Clear cart
      session[:cart] = {}
      redirect_to confirm_order_path(@order)
    else
      flash[:alert] = @order.errors.full_messages.join(', ')
      redirect_to orders_path
    end
  end

  # GET /orders/:id - Show order details
  def show
    @order = current_user.orders.includes(:order_items).find(params[:id])
  end

  # GET /orders/:id/confirm - Confirm order before payment
  def confirm
    # Order confirmation page
  end

  # POST /orders/:id/pay - Process payment
  def pay
    payment_method = params[:payment_method]
    
    case payment_method
    when 'cash'
      @order.update(status: 'confirmed')
      redirect_to order_path(@order), notice: t('user.orders.order_confirmed_cash')
    when 'vnpay'
      # Redirect to VNPay
      redirect_to vnpay_payment_url(@order), allow_other_host: true
    else
      redirect_to confirm_order_path(@order), alert: t('user.orders.select_payment_method')
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :place_id,
      :shipping_receiver_name,
      :shipping_phone,
      :shipping_address
    )
  end

  def generate_order_code
    "ORD#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
  end

  def vnpay_payment_url(order)
    # VNPay integration to be implemented
    payments_vnpay_return_path(order_id: order.id)
  end
end
