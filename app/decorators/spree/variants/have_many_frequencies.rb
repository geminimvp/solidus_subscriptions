# Spree::Variants maintain a list of the frequencies associated with them
module Spree
  module Variants
    module HaveManyFrequencies
      def self.prepended(base)
        base.has_many(
          :frequencies,
          class_name: 'SolidusSubscriptions::Frequency',
          foreign_key: 'spree_variant_id',
          inverse_of: :spree_variant
        )

        base.accepts_nested_attributes_for :frequencies
      end
    end
  end
end

Spree::Variant.prepend(::Spree::Variants::HaveManyFrequencies)
