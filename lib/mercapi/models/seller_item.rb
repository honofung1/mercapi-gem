# frozen_string_literal: true

module Mercapi
  module Models
    class SellerItem < BaseModel
      attribute :id, key: "id", required: true
      attribute :seller_id, key: "seller", required: true, type: :string
      attribute :status, key: "status", required: true
      attribute :name, key: "name", required: true
      attribute :price, key: "price", required: true, type: :integer
      attribute :thumbnails, key: "thumbnails"
      attribute :root_category_id, key: "root_category_id", type: :integer
      attribute :num_likes, key: "num_likes", type: :integer
      attribute :num_comments, key: "num_comments", type: :integer
      attribute :created, key: "created", type: :datetime
      attribute :updated, key: "updated", type: :datetime
      attribute :item_category, key: "item_category", model: ItemCategory
      attribute :shipping_from_area, key: "shipping_from_area", model: ShippingFromArea

      def full_item
        client = instance_variable_get(:@_client)
        return nil unless client

        client.item(id)
      end

      class << self
        private

        def coerce(raw, attr)
          if attr[:name] == :seller_id && raw.is_a?(Hash)
            raw["id"].to_s
          else
            super
          end
        end
      end
    end
  end
end
