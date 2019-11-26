class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :spree_line_item_id, :subscription_id, :quantity, :interval_units, :interval_length,
             :subscribable

  has_one :spree_line_item

  def subscribable
    variant = Spree::Variant.find(object.subscribable_id)
    Spree::VariantSerializer.new(variant).as_json
  end
end
