class AddPrepaidToSolidusSubscriptionsSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :solidus_subscriptions_subscriptions, :prepaid, :boolean, default: false
  end
end
