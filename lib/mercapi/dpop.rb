# frozen_string_literal: true

require "openssl"
require "securerandom"
require "jwt"

module Mercapi
  class DPoP
    def initialize
      @key = OpenSSL::PKey::EC.generate("prime256v1")
      @uuid = SecureRandom.uuid
      jwk = JWT::JWK.new(@key)
      exported = jwk.export
      @public_params = {
        crv: exported[:crv],
        kty: exported[:kty],
        x: exported[:x],
        y: exported[:y]
      }
    end

    def sign(url, method)
      payload = {
        iat: Time.now.to_i,
        jti: SecureRandom.uuid,
        htu: url,
        htm: method.to_s.upcase,
        uuid: @uuid
      }

      header = {
        typ: "dpop+jwt",
        jwk: @public_params
      }

      JWT.encode(payload, @key, "ES256", header)
    end
  end
end
