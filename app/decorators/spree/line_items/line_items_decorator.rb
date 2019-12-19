module Spree
  module LineItems
    module ClassMethods
      private

      def set_pricing_attributes
        # If the legacy method #copy_price has been overridden, handle that gracefully
        return handle_copy_price_override if respond_to?(:copy_price)

        binding.pry
        self.cost_price ||= variant.cost_price
        self.money_price = variant.price_for(pricing_options) if price.nil?
        true
      end
    end
  end
end

Spree::LineItem.prepend Spree::LineItems::ClassMethods