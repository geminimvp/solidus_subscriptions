Deface::Override.new(
  virtual_path: "spree/admin/variants/_form",
  name: "solidus_subscriptions_subscribable_fields",
  insert_bottom: "[data-hook='variants'] > fieldset:first-child > .row",
  partial: "spree/admin/variants/subscribable_fields"
)
