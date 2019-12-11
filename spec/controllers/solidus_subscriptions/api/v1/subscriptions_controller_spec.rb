require "rails_helper"

RSpec.describe SolidusSubscriptions::Api::V1::SubscriptionsController, type: :controller do
  routes { SolidusSubscriptions::Engine.routes }

  let!(:user) { create :user }
  let!(:admin) { create(:admin_user, password: 'secret', password_confirmation: 'secret') }
  let(:address_country) { create(:country) }
  let(:address_state) { create(:state, country: address_country) }
  before { user.generate_spree_api_key! }

  shared_examples "an authenticated subscription" do
    context "when the subscription belongs to user" do
      let!(:subscription) do
        create(
          :subscription,
          :with_line_item,
          actionable_date: (Date.current + 1.month ),
          user: user
        )
      end

      it { is_expected.to be_successful }
    end

    context "when the subscription belongs to someone else" do
      let!(:subscription) { create :subscription, user: create(:user) }
      it { is_expected.to be_not_found }
    end

    context 'when the subscription is canceled' do
      let!(:subscription) { create :subscription, user: user, state: 'canceled' }
      it { is_expected.to be_unprocessable }
    end
  end

  describe 'POST :create' do
    subject { post :create, params: params }
    let!(:payment_method) { create(:credit_card_payment_method, active: true, available_to_users: true) }
    let(:variant) { create(:variant) }
    let(:subscription_params) do
      {
        user_id: user.id,
        actionable_date: Date.tomorrow,
        interval_units: 'month',
        interval_length: 1,
        end_date: Date.current + 1.year,
        line_items_attributes: [{
          subscribable_id: variant.id,
          quantity: 6,
          interval_length: '1',
          interval_units: 'month',
          end_date: Date.tomorrow.to_s
        }],
        billing_address_attributes: {
          firstname: 'Ash',
          lastname: 'Ketchum',
          address1: '1 Rainbow Road',
          city: 'Palette Town',
          country_id: address_country.id,
          state_id: address_state.id,
          phone: '999-999-999',
          zipcode: '10001'
        }
      }
    end
    let(:params) do
      {
        token: admin.spree_api_key,
        subscription: subscription_params
      }
    end

    it { is_expected.to be_successful }

    it 'creates a new subscription' do
      expect { subject }.to change(SolidusSubscriptions::Subscription, :count).by(1)
      new_sub = SolidusSubscriptions::Subscription.last
      expect(new_sub.line_items.count).to eq(1)
      expect(new_sub.actionable_date).to eq(Date.tomorrow)
      expect(new_sub.billing_address).to be_present
    end
  end

  describe 'PATCH :update' do
    subject { patch :update, params: params }
    let(:params) do
      {
        id: subscription.id,
        token: user.spree_api_key,
        subscription: subscription_params
      }
    end

    let(:subscription_params) do
      {
        line_items_attributes: [{
          id: subscription.line_items.first.id,
          quantity: 6
        }],
        shipping_address_attributes: {
          firstname: 'Ash',
          lastname: 'Ketchum',
          address1: '1 Rainbow Road',
          city: 'Palette Town',
          country_id: address_country.id,
          state_id: address_state.id,
          phone: '999-999-999',
          zipcode: '10001'
        }
      }
    end

    context 'when the subscription belongs to the user' do
      let!(:subscription) { create :subscription, :with_line_item, user: user }
      it { is_expected.to be_successful }

      context 'when the params are not valid' do
        let(:subscription_params) do
          {
            line_items_attributes: [{
              id: subscription.line_items.first.id,
              quantity: -6
            }]
          }
        end

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end

      context 'when an address is being updated' do
        it 'persists the address to the users address book' do
          expect { subject }.to change { user.addresses.count }.by(1)
          expect(user.addresses.last).to eq(subscription.reload.shipping_address)
        end
      end
    end

    context 'when the subscription belongs to someone else' do
      let!(:subscription) { create :subscription, :with_line_item, user: create(:user) }
      it { is_expected.to be_not_found }
    end
  end

  describe "POST :skip" do
    let(:params) { { id: subscription.id, token: user.spree_api_key } }
    subject { post :skip, params: params }

    it_behaves_like "an authenticated subscription"
  end

  describe "POST :cancel" do
    let(:params) { { id: subscription.id, token: user.spree_api_key } }
    subject { post :cancel, params: params }

    it_behaves_like "an authenticated subscription"
  end
end
