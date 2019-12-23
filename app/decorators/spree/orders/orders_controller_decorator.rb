module Spree
    module OrdersControllerDecorator
      def self.prepended(base)
        base.before_action :apply_options, only: [:populate]
      end


      private

      def apply_options
        if params[:subscription_line_item]
          frequency_params = {
            length: params[:subscription_line_item][:interval_length],
            units: params[:subscription_line_item][:interval_units],
            spree_variant_id: params[:variant_id],
          }
          frequency = SolidusSubscriptions::Frequency.find_by!(frequency_params)
          @options = { price: frequency.price }
        end
      end

      Spree::OrdersController.prepend(self)
    end
  end
end
