module SolidusSubscriptions
  class PrepaymentDuration < ApplicationRecord
    belongs_to :spree_variant

    validates :quantity, :spree_variant, presence: true
  end
end
