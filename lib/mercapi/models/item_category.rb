# frozen_string_literal: true

module Mercapi
  module Models
    class ItemCategory < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :display_order, key: "display_order", type: :integer
      attribute :parent_category_id, key: "parent_category_id", type: :integer
      attribute :parent_category_name, key: "parent_category_name"
      attribute :root_category_id, key: "root_category_id", type: :integer
      attribute :root_category_name, key: "root_category_name"
    end

    ItemCategorySummary = ItemCategory
  end
end
