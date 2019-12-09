class CreateSolidusSubscriptionsPrepaymentDurations < ActiveRecord::Migration[5.2]
  def change
    create_table :solidus_subscriptions_prepayment_durations do |t|
      t.integer :quantity
      t.references :spree_variant, foreign_key: true, index: { name: 'index_prepayment_durations_on_variant_id' }

      t.timestamps
    end
  end
end
