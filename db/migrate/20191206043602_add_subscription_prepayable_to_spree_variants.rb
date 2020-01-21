class AddSubscriptionPrepayableToSpreeVariants < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_variants, :subscription_prepayable, :boolean, default: false
  end
end
