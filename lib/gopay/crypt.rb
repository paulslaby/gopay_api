require "digest/sha1"
require "openssl"

module GoPay

  module Crypt
    extend self

    def sha1(string)
      Digest::SHA1.hexdigest(string)
    end

    def encrypt(string)
      string = sha1(string)
      des = OpenSSL::Cipher::Cipher.new("des-ede3")
      des.encrypt
      des.key = GoPay.configuration.secret
      result = des.update(string)
      result.unpack("H*").to_s
    end

    def decrypt(encrypted_data)
      encrypted_data = bin2hex(encrypted_data)
      des = OpenSSL::Cipher::Cipher.new("des-ede3")
      des.decrypt
      des.key = GoPay.configuration.secret
      result = ""
      result << des.update(encrypted_data)
    end

    def bin2hex(bin)
      bin.scan(/../).map { | tuple | tuple.hex.chr }.to_s
    end
  end

end