# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::Models::BaseModel do
  let(:test_class) do
    Class.new(described_class) do
      attribute :name, key: "name", required: true
      attribute :count, key: "count", type: :integer
      attribute :created_at, key: "created", type: :datetime
      attribute :label, key: "label", type: :string
    end
  end

  let(:nested_class) do
    inner = test_class
    Class.new(described_class) do
      attribute :id, key: "id", required: true
      attribute :child, key: "child", model: inner
      attribute :children, key: "children", array_model: inner
    end
  end

  describe ".from_hash" do
    it "parses basic attributes" do
      instance = test_class.from_hash("name" => "hello", "count" => "42")
      expect(instance.name).to eq("hello")
      expect(instance.count).to eq(42)
    end

    it "coerces integer types from strings" do
      instance = test_class.from_hash("name" => "test", "count" => "99")
      expect(instance.count).to eq(99)
    end

    it "coerces datetime from unix timestamp" do
      ts = 1700000000
      instance = test_class.from_hash("name" => "test", "created" => ts)
      expect(instance.created_at).to eq(Time.at(ts))
    end

    it "coerces string type" do
      instance = test_class.from_hash("name" => "test", "label" => 123)
      expect(instance.label).to eq("123")
    end

    it "handles nil input" do
      expect(test_class.from_hash(nil)).to be_nil
    end

    it "leaves missing optional attributes as nil" do
      instance = test_class.from_hash("name" => "minimal")
      expect(instance.count).to be_nil
      expect(instance.created_at).to be_nil
    end

    it "parses nested models" do
      data = {
        "id" => "1",
        "child" => { "name" => "nested", "count" => "5" }
      }
      instance = nested_class.from_hash(data)
      expect(instance.child).to be_a(test_class)
      expect(instance.child.name).to eq("nested")
      expect(instance.child.count).to eq(5)
    end

    it "parses arrays of models" do
      data = {
        "id" => "1",
        "children" => [
          { "name" => "first", "count" => "1" },
          { "name" => "second", "count" => "2" }
        ]
      }
      instance = nested_class.from_hash(data)
      expect(instance.children.length).to eq(2)
      expect(instance.children.first.name).to eq("first")
      expect(instance.children.last.count).to eq(2)
    end
  end

  describe "#to_h" do
    it "serializes to a hash" do
      instance = test_class.from_hash("name" => "hello", "count" => "42")
      hash = instance.to_h
      expect(hash[:name]).to eq("hello")
      expect(hash[:count]).to eq(42)
    end

    it "excludes nil values" do
      instance = test_class.from_hash("name" => "minimal")
      hash = instance.to_h
      expect(hash).to have_key(:name)
      expect(hash).not_to have_key(:count)
    end
  end

  describe ".from_hash datetime_iso" do
    let(:iso_class) do
      Class.new(described_class) do
        attribute :timestamp, key: "timestamp", type: :datetime_iso
      end
    end

    it "coerces ISO 8601 strings to Time" do
      instance = iso_class.from_hash("timestamp" => "2026-03-20T12:00:00Z")
      expect(instance.timestamp).to be_a(Time)
      expect(instance.timestamp).to eq(Time.parse("2026-03-20T12:00:00Z"))
    end

    it "returns nil for empty datetime_iso values" do
      instance = iso_class.from_hash("timestamp" => "")
      expect(instance.timestamp).to be_nil
    end
  end

  describe "attribute inheritance" do
    it "does not share attributes between subclasses" do
      class_a = Class.new(described_class) { attribute :foo, key: "foo" }
      class_b = Class.new(described_class) { attribute :bar, key: "bar" }

      expect(class_a.attributes.map { |a| a[:name] }).to eq([:foo])
      expect(class_b.attributes.map { |a| a[:name] }).to eq([:bar])
    end
  end
end
