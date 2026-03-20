# frozen_string_literal: true

module Mercapi
  module Models
    class Color < BaseModel
      attribute :id, key: "id", required: true, type: :integer
      attribute :name, key: "name", required: true
      attribute :rgb, key: "rgb", required: true

      def rgb_code
        return nil unless rgb

        if rgb.is_a?(String)
          rgb.start_with?("#") ? rgb : "##{rgb}"
        else
          "#%06x" % rgb
        end
      end

      class << self
        private

        def coerce(raw, attr)
          if attr[:name] == :rgb && raw.is_a?(String)
            raw.delete_prefix("#").to_i(16)
          else
            super
          end
        end
      end
    end
  end
end
