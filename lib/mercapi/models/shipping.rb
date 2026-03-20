# frozen_string_literal: true

module Mercapi
  module Models
    class ShippingPayer < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :code, key: "code"
    end

    class ShippingMethod < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :is_deprecated, key: "is_deprecated"
    end

    class ShippingFromArea < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
    end

    class ShippingDuration < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :min_days, key: "min_days", required: true, type: :integer
      attribute :max_days, key: "max_days", required: true, type: :integer
    end

    class ShippingClass < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :fee, key: "fee", required: true, type: :integer
      attribute :icon_id, key: "icon_id", required: true, type: :integer
      attribute :pickup_fee, key: "pickup_fee", required: true, type: :integer
      attribute :shipping_fee, key: "shipping_fee", required: true, type: :integer
      attribute :total_fee, key: "total_fee", required: true, type: :integer
      attribute :is_pickup, key: "is_pickup", required: true
    end
  end
end
