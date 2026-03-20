# frozen_string_literal: true

module Mercapi
  module Models
    class Items < BaseModel
      attribute :items, key: "data", required: true, array_model: SellerItem
    end
  end
end
