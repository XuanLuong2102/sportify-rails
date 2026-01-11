# frozen_string_literal: true

module Agency
  class BookingsController < Agency::AgencyController
    include PaginatableConcern

    before_action :set_booking, only: [:show, :update, :approve, :reject, :confirm_payment, :complete, :cancel]

    def index
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      
      @status_counts = calculate_status_counts
    end

    def pending
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .where(status: 'pending')
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def approved
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .where(status: 'approved')
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def unpaid
      # Since payment_status column doesn't exist, show pending or approved bookings
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .where(status: ['pending', 'approved'])
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def completed
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .where(status: 'completed')
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def cancelled
      @q = agency_bookings.ransack(params[:q])
      @bookings = @q.result(distinct: true)
                    .where(status: ['cancelled', 'rejected'])
                    .includes(:user, :place_sport, :field_schedule, :payments)
                    .order(created_at: :desc)
                    .paginate(page: params[:page], per_page: params[:per_page])
      @status_counts = calculate_status_counts
      render :index
    end

    def show
      @booking = Booking.includes(:user, :place_sport, :field_schedule, :payments, :recurring_booking)
                        .find(params[:id])
    end

    def approve
      if @booking.update(status: 'approved', approved_at: Time.current, approved_by: current_user.user_id)
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.approved_successfully')
      else
        redirect_to agency_booking_path(@booking), alert: I18n.t('agency.bookings.approve_failed')
      end
    end

    def reject
      if @booking.update(status: 'rejected', rejected_at: Time.current, rejected_by: current_user.user_id)
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.rejected_successfully')
      else
        redirect_to agency_booking_path(@booking), alert: I18n.t('agency.bookings.reject_failed')
      end
    end

    def confirm_payment
      # Create a payment record instead of updating payment_status
      payment = @booking.payments.create(
        amount: @booking.total_price,
        payment_method: 'cash',
        status: 'completed',
        paid_at: Time.current
      )
      
      if payment.persisted?
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.payment_confirmed')
      else
        redirect_to agency_booking_path(@booking), alert: I18n.t('agency.bookings.payment_confirm_failed')
      end
    end

    def complete
      if @booking.update(status: 'completed', completed_at: Time.current)
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.completed_successfully')
      else
        redirect_to agency_booking_path(@booking), alert: I18n.t('agency.bookings.complete_failed')
      end
    end

    def cancel
      if @booking.update(status: 'cancelled', cancelled_at: Time.current)
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.cancelled_successfully')
      else
        redirect_to agency_booking_path(@booking), alert: I18n.t('agency.bookings.cancel_failed')
      end
    end

    def update
      if @booking.update(booking_params)
        redirect_to agency_booking_path(@booking), notice: I18n.t('agency.bookings.updated_successfully')
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def agency_bookings
      # Get bookings for place_sports that belong to agency's places
      place_sport_ids = PlaceSport.where(place_id: current_agency_place_ids).pluck(:id)
      Booking.where(place_sport_id: place_sport_ids)
    end

    def set_booking
      @booking = agency_bookings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to agency_bookings_path, alert: I18n.t('agency.bookings.not_found')
    end

    def booking_params
      params.require(:booking).permit(:notes, :internal_notes)
    end

    def calculate_status_counts
      {
        pending: agency_bookings.where(status: 'pending').count,
        approved: agency_bookings.where(status: 'approved').count,
        unpaid: agency_bookings.where(status: ['pending', 'approved']).count,
        completed: agency_bookings.where(status: 'completed').count,
        cancelled: agency_bookings.where(status: ['cancelled', 'rejected']).count
      }
    end
  end
end
