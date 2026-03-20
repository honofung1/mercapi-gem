# frozen_string_literal: true

module Mercapi
  module Models
    class Item < BaseModel
      attribute :id, key: "id", required: true
      attribute :status, key: "status", required: true
      attribute :name, key: "name", required: true
      attribute :price, key: "price", required: true, type: :integer
      attribute :seller, key: "seller", model: Seller
      attribute :description, key: "description"
      attribute :photos, key: "photos"
      attribute :photo_paths, key: "photo_paths"
      attribute :thumbnails, key: "thumbnails"
      attribute :item_category, key: "item_category", model: ItemCategory
      attribute :item_condition, key: "item_condition", model: ItemCondition
      attribute :colors, key: "colors", array_model: Color
      attribute :shipping_payer, key: "shipping_payer", model: ShippingPayer
      attribute :shipping_method, key: "shipping_method", model: ShippingMethod
      attribute :shipping_from_area, key: "shipping_from_area", model: ShippingFromArea
      attribute :shipping_duration, key: "shipping_duration", model: ShippingDuration
      attribute :shipping_class, key: "shipping_class", model: ShippingClass
      attribute :num_likes, key: "num_likes", type: :integer
      attribute :num_comments, key: "num_comments", type: :integer
      attribute :comments, key: "comments", array_model: Comment
      attribute :updated, key: "updated", type: :datetime
      attribute :created, key: "created", type: :datetime
      attribute :pager_id, key: "pager_id"
      attribute :liked, key: "liked"
      attribute :checksum, key: "checksum"
      attribute :is_dynamic_shipping_fee, key: "is_dynamic_shipping_fee"
      attribute :application_attributes, key: "application_attributes"
      attribute :is_shop_item, key: "is_shop_item"
      attribute :is_anonymous_shipping, key: "is_anonymous_shipping"
      attribute :is_web_visible, key: "is_web_visible"
      attribute :is_offerable, key: "is_offerable"
      attribute :is_organizational_user, key: "is_organizational_user"
      attribute :organizational_user_status, key: "organizational_user_status"
      attribute :is_stock_item, key: "is_stock_item"
      attribute :is_cancelable, key: "is_cancelable"
      attribute :shipped_by_worker, key: "shipped_by_worker"
      attribute :has_additional_service, key: "has_additional_service"
      attribute :has_like_list, key: "has_like_list"
      attribute :is_offerable_v2, key: "is_offerable_v2"
      attribute :auction_info, key: "auction_info", model: AuctionInfo

      def seller_profile
        client = instance_variable_get(:@_client)
        return nil unless client && seller

        client.profile(seller.id.to_s)
      end
    end
  end
end
