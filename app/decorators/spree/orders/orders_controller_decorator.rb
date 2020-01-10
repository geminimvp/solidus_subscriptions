module Spree
  module OrdersControllerDecorator
    def self.prepended(base)
      base.before_action :apply_options, only: [:populate]
    end


    private

    def apply_options
      @options = {}
      if params[:subscription_line_item]
        frequency = find_frequency(params[:variant_id])

        prepayment_duration = params[:subscription_line_item][:prepayment_duration].to_i
        if prepayment_duration > 0
          price = frequency.price * prepayment_duration
        else
          price = frequency.price
        end

        @options[:price] = price
      end
    end

    def find_frequency(variant_id)
      frequency_params = {
        length: params[:subscription_line_item][:interval_length],
        units: params[:subscription_line_item][:interval_units],
      }

      frequency = SolidusSubscriptions::Frequency.find_by(frequency_params.merge(spree_variant_id: variant_id))

      if frequency.nil?
        variant = Spree::Variant.find(variant_id).product.master
        variant.frequencies.find_by(frequency_params)
      else
        frequency
      end
    end

    Spree::OrdersController.prepend(self)
  end
end
