# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :add_item, :update_item, :remove_item, :clear]
  layout 'user'
  
  # GET /cart - Show cart
  def show
    session[:cart] ||= {}
    @cart_items = load_cart_items
    @cart_total = calculate_cart_total
    @shipping_fee = 30000
    @total_amount = @cart_total + @shipping_fee
    
    # Get place from first cart item
    if @cart_items.any?
      first_item = @cart_items.first
      @cart_place = Place.find_by(place_id: first_item[:place_id]) if first_item[:place_id]
    end
  end

  # POST /cart/add_item - Add item to cart
  def add_item
    session[:cart] ||= {}
    
    variant_id = params[:variant_id].to_s
    quantity = params[:quantity].to_i || 1
    place_id = params[:place_id].to_i
    
    # Validate place_id is provided
    unless place_id > 0
      respond_to do |format|
        error_msg = t('user.cart.place_required', default: 'Please select a place before adding to cart.')
        format.html { redirect_to request.referer || products_path, alert: error_msg }
        format.json { render json: { success: false, message: error_msg }, status: :unprocessable_entity }
      end
      return
    end

    # Enforcement: Single Place per Cart
    # Check existing cart items for place_id
    existing_place_id = nil
    session[:cart].each do |vid, item_data|
      if item_data.is_a?(Hash) && item_data['place_id']
        existing_place_id = item_data['place_id'].to_i
        break
      end
    end

    if existing_place_id && existing_place_id != place_id
      respond_to do |format|
        error_msg = t('user.cart.different_place_error', default: 'You cannot add items from different places to the same order. Please clear your cart first.')
        format.html { redirect_to request.referer || products_path, alert: error_msg }
        format.json { render json: { success: false, message: error_msg }, status: :unprocessable_entity }
      end
      return
    end
    
    # Add or update item with place_id
    if session[:cart][variant_id]
      session[:cart][variant_id]['quantity'] += quantity
    else
      session[:cart][variant_id] = { 'quantity' => quantity, 'place_id' => place_id }
    end
    
    respond_to do |format|
      format.html { redirect_to cart_path, notice: t('user.cart.item_added') }
      format.json { 
        render json: { 
          success: true, 
          cart_count: session[:cart].values.sum { |item| item['quantity'] },
          message: t('user.cart.item_added')
        }
      }
    end
  end

  # PATCH /cart/update_item - Update item quantity
  def update_item
    variant_id = params[:variant_id].to_s
    quantity = params[:quantity].to_i
    
    if quantity > 0
      session[:cart][variant_id]['quantity'] = quantity if session[:cart][variant_id]
      message = t('user.cart.item_updated')
    else
      session[:cart].delete(variant_id)
      message = t('user.cart.item_removed')
    end
    
    respond_to do |format|
      format.html { redirect_to cart_path, notice: message }
      format.json { 
        render json: { 
          success: true, 
          cart_count: session[:cart].values.sum { |item| item['quantity'] },
          message: message
        }
      }
    end
  end

  # DELETE /cart/remove_item - Remove item from cart
  def remove_item
    variant_id = params[:variant_id].to_s
    session[:cart].delete(variant_id)
    
    respond_to do |format|
      format.html { redirect_to cart_path, notice: t('user.cart.item_removed') }
      format.json { 
        render json: { 
          success: true, 
          cart_count: session[:cart].values.sum { |item| item['quantity'] },
          message: t('user.cart.item_removed')
        }
      }
    end
  end

  # DELETE /cart/clear - Clear entire cart
  def clear
    session[:cart] = {}
    redirect_to cart_path, notice: t('user.cart.cart_cleared')
  end

  private

  def load_cart_items
    return [] unless session[:cart]&.any?
    
    variant_ids = session[:cart].keys
    variants = ProductVariant.where(id: variant_ids)
                             .includes(:product_color, :product_size, product: { thumbnail_attachment: :blob })
    
    variants.map do |variant|
      cart_data = session[:cart][variant.id.to_s]
      {
        variant: variant,
        quantity: cart_data['quantity'],
        place_id: cart_data['place_id'],
        subtotal: variant.price_vnd * cart_data['quantity']
      }
    end
  end

  def calculate_cart_total
    load_cart_items.sum { |item| item[:subtotal] }
  end
end
