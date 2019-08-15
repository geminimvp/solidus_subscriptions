require 'csv'

module SolidusSubscriptions
  class DownloadService
    class << self
      def to_csv(search:, team:)
        subscriptions =
          if search
            search
              .result(distinct: true)
              .includes(:line_items, :user)
              .joins(:line_items, :user)
              .where('solidus_subscriptions_line_items.spree_line_item_id is not null')
          else
            SolidusSubscriptions::Subscription
              .includes(:line_items, :user)
              .joins(:line_items, :user)
              .where(team_id: team.id)
              .distinct('id')
          end

        CSV.generate(csv_options) do |csv|
          subscriptions.each do |subscription|
            user = subscription.user
            line_item = subscription.line_items.first.spree_line_item

            order = line_item.order
            ship_address = subscription.shipping_address || order.ship_address

            subscription_data = [
              ship_address.firstname,
              ship_address.lastname,
              user.email,
              line_item.product.name,
              line_item.variant.sku,
              subscription.created_at,
              subscription.actionable_date,
              subscription.state,
              subscription.processing_state,
            ]

            csv << subscription_data
          end
        end
      end

      def csv_options
        {
          headers: csv_headers,
          write_headers: true,
        }
      end

      def csv_headers
        [
          'first_name',
          'last_name',
          'email',
          'product_name',
          'variant_sku',
          'subscription_date',
          'next_actionable_date',
          'state',
          'processing_state',
        ]
      end
    end
  end
end
