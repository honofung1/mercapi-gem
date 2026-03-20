# frozen_string_literal: true

module Mercapi
  module Models
    class ItemCondition < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
    end
  end
end
