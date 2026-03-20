# mercapi

A Ruby gem for accessing the Mercari JP marketplace API. Search items, fetch item details, seller profiles, and seller listings with automatic DPoP-signed requests.

## Installation

Add to your Gemfile:

```ruby
gem "mercapi"
```

Then run `bundle install`. Or install directly:

```
gem install mercapi
```

## Usage

```ruby
require "mercapi"

client = Mercapi.new

# Search for items
results = client.search("nintendo switch")
results.meta.num_found  # => total results count
results.items.each do |item|
  puts "#{item.name} - ¥#{item.price}"
end

# Pagination
next_page = results.next_page
prev_page = results.prev_page

# Search with filters
results = client.search("camera",
  sort: Mercapi::SortBy::SORT_PRICE,
  order: Mercapi::SortOrder::ORDER_ASC,
  price_min: 1000,
  price_max: 50000,
  status: [Mercapi::Status::STATUS_ON_SALE],
  category_id: [123],
  shipping_method: [Mercapi::SearchShippingMethod::SHIPPING_METHOD_ANONYMOUS]
)

# Get full item details
item = client.item("m12345678")
item.name           # => "Nintendo Switch Console"
item.description    # => full description text
item.price          # => 32000
item.seller.name    # => "game_seller_jp"
item.item_condition.name  # => "Near mint"
item.shipping_from_area.name  # => "Tokyo"

# Convenience: get full item from search result
full_item = results.items.first.full_item

# Get seller profile
profile = client.profile("123456")
profile.name              # => "game_seller_jp"
profile.ratings.good      # => 150
profile.introduction      # => bio text
profile.follower_count    # => 85

# Get seller's listings
items = client.items("123456")
items.items.each do |seller_item|
  puts seller_item.name
end

# Proxy support
client = Mercapi.new(proxy: "http://proxy.example.com:8080")
```

## Search Filters

| Parameter | Type | Description |
|-----------|------|-------------|
| `sort` | `String` | `SortBy::SORT_SCORE`, `SORT_CREATED_TIME`, `SORT_PRICE`, `SORT_NUM_LIKES` |
| `order` | `String` | `SortOrder::ORDER_DESC`, `ORDER_ASC` |
| `status` | `Array` | `Status::STATUS_ON_SALE`, `STATUS_SOLD_OUT` |
| `price_min` | `Integer` | Minimum price |
| `price_max` | `Integer` | Maximum price |
| `category_id` | `Array<Integer>` | Category IDs |
| `brand_id` | `Array<Integer>` | Brand IDs |
| `item_condition_id` | `Array<Integer>` | Item condition IDs |
| `shipping_payer_id` | `Array<Integer>` | Shipping payer IDs |
| `shipping_method` | `Array<String>` | Shipping method enums |
| `color_id` | `Array<Integer>` | Color IDs |
| `exclude_keyword` | `String` | Keywords to exclude |

## Development

```
bundle install
bundle exec rspec
```

## Credits

This gem is inspired by the Python [mercapi](https://github.com/take-kun/mercapi) library

## License

MIT
