module Spree
  module Orders
    module SubscriptionMatch
      def subscription_match(line_item, options)
        line_item.subscription_line_items.exists?(
          interval_length: options[:frequency].length,
          interval_units: options[:frequency].units,
          end_date: options[:end_date]
        )
      end
    end
  end
end

Spree::Order.prepend Spree::Orders::SubscriptionMatch
