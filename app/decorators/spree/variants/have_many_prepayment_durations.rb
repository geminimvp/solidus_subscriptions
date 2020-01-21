# Spree::Variants maintain a list of the prepayment_durations associated with them
module Spree
  module Variants
    module HaveManyPrepaymentDurations
      def self.prepended(base)
        base.has_many(
          :prepayment_durations,
          class_name: 'SolidusSubscriptions::PrepaymentDuration',
          foreign_key: 'spree_variant_id',
          inverse_of: :spree_variant
        )

        base.accepts_nested_attributes_for :prepayment_durations
      end
    end
  end
end

Spree::Variant.prepend(::Spree::Variants::HaveManyPrepaymentDurations)
