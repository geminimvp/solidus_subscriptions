class AddPrepaidToSolidusSubscriptionsLineItem < ActiveRecord::Migration[5.2]
  def change
    add_column :solidus_subscriptions_line_items, :prepaid, :boolean, default: false
  end
end
