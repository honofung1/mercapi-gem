# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::Models::Item do
  let(:data) { fixture("item_response")["data"] }
  let(:item) { described_class.from_hash(data) }

  it "parses basic item attributes" do
    expect(item.id).to eq("m12345678")
    expect(item.name).to eq("Nintendo Switch Console")
    expect(item.status).to eq("on_sale")
    expect(item.price).to eq(32000)
    expect(item.description).to include("Used Nintendo Switch")
  end

  it "parses nested seller" do
    expect(item.seller).to be_a(Mercapi::Models::Seller)
    expect(item.seller.id).to eq(123456)
    expect(item.seller.name).to eq("game_seller_jp")
    expect(item.seller.num_sell_items).to eq(42)
  end

  it "parses seller ratings" do
    ratings = item.seller.ratings
    expect(ratings).to be_a(Mercapi::Models::Seller::Ratings)
    expect(ratings.good).to eq(150)
    expect(ratings.normal).to eq(5)
    expect(ratings.bad).to eq(1)
  end

  it "parses item_category" do
    cat = item.item_category
    expect(cat).to be_a(Mercapi::Models::ItemCategory)
    expect(cat.id).to eq(945)
    expect(cat.name).to eq("Television game body")
    expect(cat.parent_category_name).to eq("Television game")
    expect(cat.root_category_name).to eq("Entertainment & Hobby")
  end

  it "parses item_condition" do
    cond = item.item_condition
    expect(cond.id).to eq(2)
    expect(cond.name).to eq("Near mint")
  end

  it "parses shipping details" do
    expect(item.shipping_payer.name).to eq("Shipping included (seller bears)")
    expect(item.shipping_from_area.name).to eq("Tokyo")
    expect(item.shipping_duration.min_days).to eq(1)
    expect(item.shipping_duration.max_days).to eq(2)
  end

  it "parses comments" do
    expect(item.comments.length).to eq(1)
    comment = item.comments.first
    expect(comment.message).to eq("Is this still available?")
    expect(comment.user.name).to eq("buyer_san")
  end

  it "parses datetime fields" do
    expect(item.created).to eq(Time.at(1700000000))
    expect(item.updated).to eq(Time.at(1700100000))
  end

  it "parses boolean fields" do
    expect(item.is_anonymous_shipping).to eq(true)
    expect(item.is_offerable).to eq(true)
    expect(item.liked).to eq(false)
  end

  it "parses auction_info" do
    auction_info = item.auction_info
    expect(auction_info).to be_a(Mercapi::Models::AuctionInfo)
    expect(auction_info.id).to eq("a98765432")
    expect(auction_info.start_time).to eq(Time.at(1700000000))
    expect(auction_info.expected_end_time).to eq(Time.at(1700086400))
    expect(auction_info.bid_deadline_duration_seconds).to eq(300)
    expect(auction_info.bid_total_duration_seconds).to eq(86400)
    expect(auction_info.total_bids).to eq(12)
    expect(auction_info.initial_price).to eq(25000)
    expect(auction_info.highest_bid).to eq(32000)
    expect(auction_info.state).to eq("active")
    expect(auction_info.auction_type).to eq("standard")
  end

  it "returns nil auction_info for non-auction items" do
    data_without_auction = data.reject { |k, _| k == "auction_info" }
    non_auction_item = described_class.from_hash(data_without_auction)
    expect(non_auction_item.auction_info).to be_nil
  end
end
