class PaymentSerializer < BaseSerializer
  attributes :id, :user_id, :booking_id, :recurring_booking_id,
             :amount, :payment_method, :status, :paid_at

  belongs_to :user
  belongs_to :booking
  belongs_to :recurring_booking
end
