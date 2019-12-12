module SolidusSubscriptions
  class Frequency < ApplicationRecord
    belongs_to :spree_variant, class_name: 'Spree::Variant', inverse_of: :frequencies

    validates :length, :units, :spree_variant, presence: true
  end
end
