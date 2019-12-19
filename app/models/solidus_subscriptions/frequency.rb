module SolidusSubscriptions
  class Frequency < ApplicationRecord

    include Spree::DefaultPrice

    belongs_to :spree_variant, class_name: 'Spree::Variant', inverse_of: :frequencies

    has_many(
      :prices,
      class_name: 'Spree::Price',
      foreign_key: 'solidus_subscriptions_frequency_id',
    )

    accepts_nested_attributes_for :prices

    validates :length, :units, :spree_variant, presence: true
  end
end
