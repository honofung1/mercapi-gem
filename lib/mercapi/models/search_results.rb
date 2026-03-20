# frozen_string_literal: true

module Mercapi
  module Models
    class Meta < BaseModel
      attribute :next_page_token, key: "nextPageToken", required: true
      attribute :prev_page_token, key: "previousPageToken", required: true
      attribute :num_found, key: "numFound", required: true, type: :integer
    end

    class SearchResults < BaseModel
      attribute :meta, key: "meta", required: true, model: Meta
      attribute :items, key: "items", required: true, array_model: SearchResultItem

      def next_page
        token = meta&.next_page_token
        raise IncorrectRequestError, "No next page available" if token.nil? || token.empty?

        client = instance_variable_get(:@_client)
        request = instance_variable_get(:@_request)
        raise Error, "No client reference available" unless client && request

        client.search(request[:keyword], **request[:filters].merge(page_token: token))
      end

      def prev_page
        token = meta&.prev_page_token
        raise IncorrectRequestError, "No previous page available" if token.nil? || token.empty?

        client = instance_variable_get(:@_client)
        request = instance_variable_get(:@_request)
        raise Error, "No client reference available" unless client && request

        client.search(request[:keyword], **request[:filters].merge(page_token: token))
      end
    end
  end
end
