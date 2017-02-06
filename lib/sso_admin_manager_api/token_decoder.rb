module SsoAdminManagerApi
  class TokenDecoder
    require "jwt"

    def self.decode(token)
      options = { algorithm: 'RS256' }
      JWT.decode(token, public_key, true, { algorithm: "RS256" })
    end

    def self.public_key
      certificate.public_key
    end

    def self.cert_file_path
      File.join(Rails.root, 'config', 'public_key_certs', cert_file_name)
    end

    def self.cert_file_name
      return "nfg_production.cer" if Rails.env.production?
      "nfg_qa.cer"
    end

    def self.certificate
      @@certificate ||= OpenSSL::X509::Certificate.new(File.read(cert_file_path))
    end

  end

end