# frozen_string_literal: true

module Mercapi
  module Models
    class Comment < BaseModel
      class User < BaseModel
        attribute :id, key: "id", required: true, type: :integer
        attribute :name, key: "name", required: true
        attribute :photo, key: "photo_url"
        attribute :photo_thumbnail, key: "photo_thumbnail_url"
      end

      attribute :id, key: "id", required: true, type: :integer
      attribute :message, key: "message", required: true
      attribute :user, key: "user", model: User
      attribute :created, key: "created", type: :datetime
    end
  end
end
