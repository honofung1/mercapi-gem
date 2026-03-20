# frozen_string_literal: true

require "securerandom"

module Mercapi
  module SortBy
    SORT_SCORE          = "SORT_SCORE"
    SORT_CREATED_TIME   = "SORT_CREATED_TIME"
    SORT_PRICE          = "SORT_PRICE"
    SORT_NUM_LIKES      = "SORT_NUM_LIKES"
  end

  module SortOrder
    ORDER_DESC = "ORDER_DESC"
    ORDER_ASC  = "ORDER_ASC"
  end

  module Status
    STATUS_ON_SALE  = "STATUS_ON_SALE"
    STATUS_TRADING  = "STATUS_TRADING"
    STATUS_SOLD_OUT = "STATUS_SOLD_OUT"
  end

  module SearchShippingMethod
    SHIPPING_METHOD_ANONYMOUS  = "SHIPPING_METHOD_ANONYMOUS"
    SHIPPING_METHOD_JAPAN_POST = "SHIPPING_METHOD_JAPAN_POST"
    SHIPPING_METHOD_NO_OPTION  = "SHIPPING_METHOD_NO_OPTION"
  end

  class SearchRequest
    DEFAULTS = {
      sort: SortBy::SORT_SCORE,
      order: SortOrder::ORDER_DESC,
      status: [Status::STATUS_ON_SALE],
      page_size: 120
    }.freeze

    attr_reader :keyword, :options

    def initialize(keyword, **options)
      @keyword = keyword
      @options = DEFAULTS.merge(options)
    end

    def to_h
      status = Array(@options[:status]).dup
      if status.include?(Status::STATUS_SOLD_OUT) && !status.include?(Status::STATUS_TRADING)
        status << Status::STATUS_TRADING
      end

      {
        "userId" => "",
        "pageSize" => @options[:page_size],
        "pageToken" => @options[:page_token] || "",
        "searchSessionId" => SecureRandom.hex(16),
        "indexRouting" => "INDEX_ROUTING_UNSPECIFIED",
        "thumbnailTypes" => [],
        "searchCondition" => {
          "keyword" => @keyword,
          "sort" => @options[:sort],
          "order" => @options[:order],
          "status" => status,
          "sizeId" => @options[:size_id] || [],
          "categoryId" => @options[:category_id] || [],
          "brandId" => @options[:brand_id] || [],
          "sellerId" => @options[:seller_id] || [],
          "priceMin" => @options[:price_min] || 0,
          "priceMax" => @options[:price_max] || 0,
          "itemConditionId" => @options[:item_condition_id] || [],
          "shippingPayerId" => @options[:shipping_payer_id] || [],
          "shippingFromArea" => @options[:shipping_from_area] || [],
          "shippingMethod" => @options[:shipping_method] || [],
          "colorId" => @options[:color_id] || [],
          "hasCoupon" => @options[:has_coupon] || false,
          "attributes" => @options[:attributes] || [],
          "itemTypes" => @options[:item_types] || [],
          "skuIds" => @options[:sku_ids] || [],
          "excludeKeyword" => @options[:exclude_keyword] || ""
        },
        "defaultDatasets" => [],
        "serviceFrom" => "suruga"
      }
    end
  end
end
