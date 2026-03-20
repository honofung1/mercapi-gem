# frozen_string_literal: true

module Mercapi
  module Models
    class SearchResultItem < BaseModel
      attribute :id, key: "id", required: true
      attribute :name, key: "name", required: true
      attribute :price, key: "price", required: true, type: :integer
      attribute :seller_id, key: "sellerId"
      attribute :status, key: "status"
      attribute :created, key: "created", type: :datetime
      attribute :updated, key: "updated", type: :datetime
      attribute :thumbnails, key: "thumbnails"
      attribute :item_type, key: "itemType"
      attribute :item_condition_id, key: "itemConditionId", type: :integer
      attribute :shipping_payer_id, key: "shippingPayerId", type: :integer
      attribute :shipping_method_id, key: "shippingMethodId", type: :integer
      attribute :category_id, key: "categoryId", type: :integer
      attribute :is_no_price, key: "isNoPrice"
      attribute :auction, key: "auction", model: Auction

      def real_price
        is_no_price ? nil : price
      end

      def full_item
        client = instance_variable_get(:@_client)
        return nil unless client

        client.item(id)
      end

      def seller
        client = instance_variable_get(:@_client)
        return nil unless client || seller_id.nil?

        client.profile(seller_id)
      end
    end
  end
end
