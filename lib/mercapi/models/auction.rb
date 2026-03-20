# frozen_string_literal: true

module Mercapi
  module Models
    class Auction < BaseModel
      attribute :id, key: "id"
      attribute :bid_deadline, key: "bidDeadline", type: :datetime_iso
      attribute :total_bid, key: "totalBid", type: :integer
      attribute :highest_bid, key: "highestBid", type: :integer
    end

    class AuctionInfo < BaseModel
      attribute :id, key: "id"
      attribute :start_time, key: "start_time", type: :datetime
      attribute :expected_end_time, key: "expected_end_time", type: :datetime
      attribute :bid_deadline_duration_seconds, key: "bid_deadline_duration_seconds", type: :integer
      attribute :bid_total_duration_seconds, key: "bid_total_duration_seconds", type: :integer
      attribute :total_bids, key: "total_bids", type: :integer
      attribute :initial_price, key: "initial_price", type: :integer
      attribute :highest_bid, key: "highest_bid", type: :integer
      attribute :state, key: "state"
      attribute :auction_type, key: "auction_type"
    end
  end
end
