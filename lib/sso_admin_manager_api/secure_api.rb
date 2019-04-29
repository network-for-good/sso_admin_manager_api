module SsoAdminManagerApi
  module TokenAuthentication
    def authorize_nfg_request!
      authorization_token = request.authorization || params[:jwt_token]
      raise JWT::DecodeError.new unless authorization_token

      token = authorization_token.gsub("Bearer ", "").strip
      decoded_token = ::TokenDecoder::Decoder.decode(token, Rails.env)
    rescue JWT::DecodeError
      render(json: { errors: 'A token must be passed.'}, status: 500)
    rescue JWT::ExpiredSignature
      render(json: { errors: 'The token has expired.'}, status: 500)
    rescue JWT::InvalidIssuerError
      render(json: { errors: 'The token does not have a valid issuer.'}, status: 500)
    rescue JWT::InvalidIatError
      render(json: { errors: 'The token does not have a valid "issued at" time.'}, status: 500)
    end
  end
end