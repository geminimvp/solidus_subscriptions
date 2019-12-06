class AddPrepaidToSubscription < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions, :prepaid, :boolean
  end
end
