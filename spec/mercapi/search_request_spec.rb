# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::SearchRequest do
  describe "#to_h" do
    it "builds a valid search payload with defaults" do
      request = described_class.new("nintendo switch")
      payload = request.to_h

      expect(payload["userId"]).to eq("")
      expect(payload["pageSize"]).to eq(120)
      expect(payload["pageToken"]).to eq("")
      expect(payload["searchSessionId"]).to match(/\A[0-9a-f]{32}\z/)
      expect(payload["indexRouting"]).to eq("INDEX_ROUTING_UNSPECIFIED")
      expect(payload["serviceFrom"]).to eq("suruga")

      condition = payload["searchCondition"]
      expect(condition["keyword"]).to eq("nintendo switch")
      expect(condition["sort"]).to eq("SORT_SCORE")
      expect(condition["order"]).to eq("ORDER_DESC")
      expect(condition["status"]).to eq(["STATUS_ON_SALE"])
      expect(condition["priceMin"]).to eq(0)
      expect(condition["priceMax"]).to eq(0)
    end

    it "applies custom filters" do
      request = described_class.new("camera",
        sort: Mercapi::SortBy::SORT_PRICE,
        order: Mercapi::SortOrder::ORDER_ASC,
        price_min: 1000,
        price_max: 50000,
        category_id: [123, 456]
      )
      condition = request.to_h["searchCondition"]

      expect(condition["sort"]).to eq("SORT_PRICE")
      expect(condition["order"]).to eq("ORDER_ASC")
      expect(condition["priceMin"]).to eq(1000)
      expect(condition["priceMax"]).to eq(50000)
      expect(condition["categoryId"]).to eq([123, 456])
    end

    it "auto-includes STATUS_TRADING when STATUS_SOLD_OUT is set" do
      request = described_class.new("test",
        status: [Mercapi::Status::STATUS_SOLD_OUT]
      )
      condition = request.to_h["searchCondition"]

      expect(condition["status"]).to include("STATUS_SOLD_OUT", "STATUS_TRADING")
    end

    it "does not duplicate STATUS_TRADING if already present" do
      request = described_class.new("test",
        status: [Mercapi::Status::STATUS_SOLD_OUT, Mercapi::Status::STATUS_TRADING]
      )
      condition = request.to_h["searchCondition"]

      trading_count = condition["status"].count { |s| s == "STATUS_TRADING" }
      expect(trading_count).to eq(1)
    end

    it "supports page_token for pagination" do
      request = described_class.new("test", page_token: "v1:120")
      payload = request.to_h

      expect(payload["pageToken"]).to eq("v1:120")
    end
  end
end
