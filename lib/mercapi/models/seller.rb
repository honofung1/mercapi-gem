# frozen_string_literal: true

module Mercapi
  module Models
    class Seller < BaseModel
      class Ratings < BaseModel
        attribute :good, key: "good", required: true, type: :integer
        attribute :normal, key: "normal", required: true, type: :integer
        attribute :bad, key: "bad", required: true, type: :integer
      end

      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :photo, key: "photo_url"
      attribute :photo_thumbnail, key: "photo_thumbnail_url"
      attribute :register_sms_confirmation, key: "register_sms_confirmation"
      attribute :register_sms_confirmation_at, key: "register_sms_confirmation_at"
      attribute :created, key: "created", type: :datetime
      attribute :num_sell_items, key: "num_sell_items", type: :integer
      attribute :ratings, key: "ratings", model: Ratings
      attribute :num_ratings, key: "num_ratings", type: :integer
      attribute :score, key: "score", type: :integer
      attribute :is_official, key: "is_official"
      attribute :quick_shipper, key: "quick_shipper"
      attribute :star_rating_score, key: "star_rating_score", type: :integer
    end
  end
end
