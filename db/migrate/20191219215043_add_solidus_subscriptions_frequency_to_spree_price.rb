class AddSolidusSubscriptionsFrequencyToSpreePrice < ActiveRecord::Migration[5.2]
  def change
    add_reference :spree_prices, :solidus_subscriptions_frequency, foreign_key: true
  end
end
