module Spree
  module Orders
    module SubscriptionMatch
      def subscription_match(line_item, options)
        # this makes sure a new line_item is created whenever a subscription_line_item is added
        false
      end
    end
  end
end

Spree::Order.prepend Spree::Orders::SubscriptionMatch
