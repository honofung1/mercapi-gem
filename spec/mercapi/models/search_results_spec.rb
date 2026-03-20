# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::Models::SearchResults do
  let(:data) { fixture("search_response") }
  let(:results) { described_class.from_hash(data) }

  it "parses meta" do
    expect(results.meta).to be_a(Mercapi::Models::Meta)
    expect(results.meta.next_page_token).to eq("v1:120")
    expect(results.meta.prev_page_token).to eq("")
    expect(results.meta.num_found).to eq(2456)
  end

  it "parses items array" do
    expect(results.items.length).to eq(2)
    expect(results.items).to all(be_a(Mercapi::Models::SearchResultItem))
  end

  describe "SearchResultItem" do
    let(:item) { results.items.first }

    it "parses basic attributes" do
      expect(item.id).to eq("m12345678")
      expect(item.name).to eq("Nintendo Switch Console")
      expect(item.price).to eq(32000)
      expect(item.seller_id).to eq("123456")
      expect(item.category_id).to eq(945)
    end

    it "parses datetime fields" do
      expect(item.created).to eq(Time.at(1700000000))
    end

    it "returns real_price when not no_price" do
      expect(item.is_no_price).to eq(false)
      expect(item.real_price).to eq(32000)
    end

    it "returns nil real_price when is_no_price" do
      no_price_data = data["items"][0].merge("isNoPrice" => true)
      item = Mercapi::Models::SearchResultItem.from_hash(no_price_data)
      expect(item.real_price).to be_nil
    end

    it "parses auction data" do
      auction = item.auction
      expect(auction).to be_a(Mercapi::Models::Auction)
      expect(auction.id).to eq("a98765432")
      expect(auction.bid_deadline).to be_a(Time)
      expect(auction.bid_deadline).to eq(Time.parse("2026-03-20T12:00:00Z"))
      expect(auction.total_bid).to eq(8)
      expect(auction.highest_bid).to eq(32000)
    end

    it "returns nil auction for non-auction items" do
      second_item = results.items[1]
      expect(second_item.auction).to be_nil
    end
  end
end
