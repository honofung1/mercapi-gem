# frozen_string_literal: true

require "spec_helper"

RSpec.describe Mercapi::DPoP do
  subject(:dpop) { described_class.new }

  def decode_jwt_part(token, index)
    part = token.split(".")[index]
    # Add proper base64url padding
    padded = part + "=" * ((4 - part.length % 4) % 4)
    JSON.parse(Base64.urlsafe_decode64(padded))
  end

  describe "#sign" do
    let(:url) { "https://api.mercari.jp/v2/entities:search" }
    let(:method) { "POST" }
    let(:token) { dpop.sign(url, method) }

    it "returns a JWT string with three parts" do
      parts = token.split(".")
      expect(parts.length).to eq(3)
    end

    it "has correct header fields" do
      header = decode_jwt_part(token, 0)
      expect(header["typ"]).to eq("dpop+jwt")
      expect(header["alg"]).to eq("ES256")
      expect(header["jwk"]).to include("crv", "kty", "x", "y")
      expect(header["jwk"]["kty"]).to eq("EC")
      expect(header["jwk"]["crv"]).to eq("P-256")
    end

    it "has correct payload fields" do
      payload = decode_jwt_part(token, 1)
      expect(payload["htu"]).to eq(url)
      expect(payload["htm"]).to eq("POST")
      expect(payload["iat"]).to be_a(Integer)
      expect(payload["jti"]).to match(/\A[0-9a-f\-]{36}\z/)
      expect(payload["uuid"]).to match(/\A[0-9a-f\-]{36}\z/)
    end

    it "produces verifiable signatures" do
      header_json = decode_jwt_part(token, 0)
      jwk_data = header_json["jwk"].transform_keys(&:to_sym)

      jwk = JWT::JWK.new(jwk_data)
      decoded = JWT.decode(token, jwk.public_key, true, algorithms: ["ES256"])
      expect(decoded.first["htu"]).to eq(url)
    end

    it "generates unique jti for each call" do
      token1 = dpop.sign(url, method)
      token2 = dpop.sign(url, method)

      payload1 = decode_jwt_part(token1, 1)
      payload2 = decode_jwt_part(token2, 1)

      expect(payload1["jti"]).not_to eq(payload2["jti"])
    end

    it "uses the same uuid across calls" do
      token1 = dpop.sign(url, method)
      token2 = dpop.sign(url, method)

      payload1 = decode_jwt_part(token1, 1)
      payload2 = decode_jwt_part(token2, 1)

      expect(payload1["uuid"]).to eq(payload2["uuid"])
    end
  end
end
