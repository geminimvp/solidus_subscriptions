module SolidusSubscriptions
  class Frequency < ApplicationRecord

    include Spree::DefaultPrice

    has_one :default_price,
      -> { with_deleted.currently_valid.with_default_attributes },
      class_name: 'Spree::Price',
      foreign_key: :solidus_subscriptions_frequency_id,
      inverse_of: :frequency,
      dependent: :destroy,
      autosave: true

    belongs_to :spree_variant, class_name: 'Spree::Variant', inverse_of: :frequencies

    has_many(
      :prices,
      class_name: 'Spree::Price',
      foreign_key: 'solidus_subscriptions_frequency_id',
      inverse_of: 'frequency'
    )

    accepts_nested_attributes_for :prices

    validates :length, :units, :spree_variant, presence: true

    def find_or_build_default_price
      default_price || build_default_price(Spree::Config.default_pricing_options.desired_attributes.merge(variant_id: 0))
    end

    def price_hash
      pricing_options = Spree::Config.default_pricing_options
      EngineCms::VariantSerializer.new(spree_variant).price_hash(pricing_options, price)
    end

    def price
      default_price&.price || spree_variant.price
    end

  end
end
