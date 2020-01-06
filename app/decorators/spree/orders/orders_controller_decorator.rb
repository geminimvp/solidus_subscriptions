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

        prepayment_duration = params[:subscription_line_item][:prepayment_duration].to_i
        if prepayment_duration > 0
          price = frequency.price * prepayment_duration
        else
          price = frequency.price
        end

        @options = { price: price }
      end
    end

    Spree::OrdersController.prepend(self)
  end
end
