# frozen_string_literal: true

module Mercapi
  module Models
    class Profile < BaseModel
      class Ratings < BaseModel
        attribute :good, key: "good", required: true, type: :integer
        attribute :normal, key: "normal", required: true, type: :integer
        attribute :bad, key: "bad", required: true, type: :integer
      end

      class PolarizedRatings < BaseModel
        attribute :good, key: "good", required: true, type: :integer
        attribute :bad, key: "bad", required: true, type: :integer
      end

      attribute :id, key: "id", required: true
      attribute :name, key: "name", required: true
      attribute :photo_url, key: "photo_url"
      attribute :photo_thumbnail_url, key: "photo_thumbnail_url"
      attribute :register_sms_confirmation, key: "register_sms_confirmation"
      attribute :ratings, key: "ratings", model: Ratings
      attribute :polarized_ratings, key: "polarized_ratings", model: PolarizedRatings
      attribute :num_ratings, key: "num_ratings", type: :integer
      attribute :star_rating_score, key: "star_rating_score", type: :integer
      attribute :is_followable, key: "is_followable"
      attribute :is_blocked, key: "is_blocked"
      attribute :following_count, key: "following_count", type: :integer
      attribute :follower_count, key: "follower_count", type: :integer
      attribute :score, key: "score", type: :integer
      attribute :created, key: "created", type: :datetime
      attribute :proper, key: "proper"
      attribute :introduction, key: "introduction"
      attribute :is_official, key: "is_official"
      attribute :num_sell_items, key: "num_sell_items", type: :integer
      attribute :num_ticket, key: "num_ticket", type: :integer
      attribute :bounce_mail_flag, key: "bounce_mail_flag"
      attribute :current_point, key: "current_point", type: :integer
      attribute :current_sales, key: "current_sales", type: :integer
      attribute :is_organizational_user, key: "is_organizational_user"
    end
  end
end
