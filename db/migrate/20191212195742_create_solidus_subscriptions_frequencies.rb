class CreateSolidusSubscriptionsFrequencies < ActiveRecord::Migration[5.2]
  def change
    create_table :solidus_subscriptions_frequencies do |t|
      t.integer :length
      t.string :units
      t.references :spree_variant, foreign_key: true

      t.timestamps
    end
  end
end
