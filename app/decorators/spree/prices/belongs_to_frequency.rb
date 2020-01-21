# Spree::Variants maintain a list of the frequencies associated with them
module Spree
  module Prices
    module BelongsToFrequency
      def self.prepended(base)
        base.belongs_to(
          :frequency,
          class_name: 'SolidusSubscriptions::Frequency',
          foreign_key: 'solidus_subscriptions_frequency_id',
          inverse_of: 'prices'
        )
      end
    end
  end
end

Spree::Price.prepend(::Spree::Prices::BelongsToFrequency)
