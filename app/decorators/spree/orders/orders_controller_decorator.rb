module Spree
  module OrdersControllerDecorator
    def self.prepended(base)
      base.before_action :apply_options, only: [:populate]
    end


    private

    def apply_options
      @options = {}
      if params[:subscription_line_item]
        price = find_price(params[:variant_id])
        prepayment_duration = params[:subscription_line_item][:prepayment_duration].to_i
        price = price * prepayment_duration if prepayment_duration > 0

        @options[:price] = price
      end
    end

    def find_price(variant_id)
      frequency_params = {
        length: params[:subscription_line_item][:interval_length],
        units: params[:subscription_line_item][:interval_units],
      }

      frequency = SolidusSubscriptions::Frequency.find_by(frequency_params.merge(spree_variant_id: variant_id))
      variant = Spree::Variant.find(variant_id)

      if frequency.nil?
        master_variant = variant.product.master
        frequency =  master_variant.frequencies.find_by(frequency_params)
      end

      frequency&.price || variant.price
    end

    Spree::OrdersController.prepend(self)
  end
end
