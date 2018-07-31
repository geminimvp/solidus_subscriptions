class AddSubscriptionColumnsToSpreeVariants < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_variants, :subscribable, :boolean, default: false
    add_column :spree_variants, :subscription_interval_length, :integer
    add_column :spree_variants, :subscription_interval_units, :string
  end
end
