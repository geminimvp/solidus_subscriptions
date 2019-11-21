class SolidusSubscriptions::Api::V1::SubscriptionsController < Spree::Api::BaseController
  before_action :load_subscription, only: [:cancel, :update, :skip]

  def create
    authorize! :create, SolidusSubscriptions::Subscription
    @subscription = SolidusSubscriptions::Subscription.new(subscription_params)
    if @subscription.save
      render json: @subscription, status: 201
    else
      render json: @subscription.errors.to_json, status: 422
    end
  end

  def update
    binding.pry
    if @subscription.update(subscription_params)
      persist_subscription_addresses(@subscription)
      if params[:full_json]
        render json: SubscriptionSerializer.new(@subscription).to_json(include: '**')
      else
        render json: @subscription.to_json(include: [:line_items, :wallet_payment_source, :shipping_address, :billing_address])
      end
    else
      render json: @subscription.errors.to_json, status: 422
    end
  end

  def skip
    if @subscription.skip
      render json: @subscription.to_json
    else
      render json: @subscription.errors.to_json, status: 422
    end
  end

  def cancel
    if @subscription.cancel
      render json: @subscription.to_json
    else
      render json: @subscription.errors.to_json, status: 422
    end
  end

  private

  def load_subscription
    @subscription = current_api_user.subscriptions.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(
      :email,
      :user_id,
      :actionable_date,
      :interval_length,
      :interval_units,
      :end_date,
      line_items_attributes: line_item_attributes,
      shipping_address_attributes: Spree::PermittedAttributes.address_attributes,
      billing_address_attributes: Spree::PermittedAttributes.address_attributes,
      wallet_payment_source_attributes: [:user_id, payment_source_attributes: [:source_type, :nonce, :payment_type, :payment_method_id]]
    ).merge(team_id: current_team.id)
  end

  def line_item_attributes
    SolidusSubscriptions::Config.subscription_line_item_attributes + [:id]
  end

  def persist_subscription_addresses(subscription)
    return unless subscription.billing_address || subscription.shipping_address

    addresses = OpenStruct.new(ship_address: subscription.shipping_address, bill_address: subscription.billing_address)
    subscription.user.persist_order_address(addresses)
  end
end
