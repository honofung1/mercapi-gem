# frozen_string_literal: true

require "time"

module Mercapi
  module Models
    class BaseModel
      class << self
        def attributes
          @attributes ||= []
        end

        def attribute(name, key: nil, required: false, model: nil, array_model: nil, type: nil)
          attr = {
            name: name,
            key: key || name.to_s,
            required: required,
            model: model,
            array_model: array_model,
            type: type
          }
          attributes << attr
          attr_reader name
        end

        def inherited(subclass)
          super
          subclass.instance_variable_set(:@attributes, [])
        end

        def from_hash(data)
          return nil if data.nil?

          instance = new
          attributes.each do |attr|
            raw = data[attr[:key]]
            raw = data[attr[:key].to_sym] if raw.nil?

            if raw.nil?
              next
            end

            value = coerce(raw, attr)
            instance.instance_variable_set(:"@#{attr[:name]}", value)
          end
          instance
        end

        private

        def coerce(raw, attr)
          if attr[:model]
            attr[:model].from_hash(raw)
          elsif attr[:array_model]
            Array(raw).map { |item| attr[:array_model].from_hash(item) }
          elsif attr[:type] == :datetime
            raw.to_s.empty? ? nil : Time.at(raw.to_i)
          elsif attr[:type] == :datetime_iso
            raw.to_s.empty? ? nil : Time.parse(raw.to_s)
          elsif attr[:type] == :integer
            raw.to_i
          elsif attr[:type] == :string
            raw.to_s
          else
            raw
          end
        end
      end

      def initialize
        # Attributes set via from_hash
      end

      def to_h
        self.class.attributes.each_with_object({}) do |attr, hash|
          value = instance_variable_get(:"@#{attr[:name]}")
          next if value.nil?

          hash[attr[:name]] = case value
                              when BaseModel then value.to_h
                              when Array then value.map { |v| v.is_a?(BaseModel) ? v.to_h : v }
                              else value
                              end
        end
      end
    end
  end
end
