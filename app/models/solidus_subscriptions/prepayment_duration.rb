module SolidusSubscriptions
  class PrepaymentDuration < ApplicationRecord
    belongs_to :spree_variant, class_name: 'Spree::Variant', inverse_of: :prepayment_durations

    validates :quantity, :spree_variant, presence: true
  end
end
