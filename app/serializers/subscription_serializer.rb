class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :actionable_date, :end_date, :state, :user_id, :shipping_address_id,
             :interval_length, :interval_units, :billing_address_id, :email, :total_cost, :line_items

  has_one :user
  has_one :wallet_payment_source
  has_one :billing_address
  has_one :shipping_address
  has_many :line_items
end
