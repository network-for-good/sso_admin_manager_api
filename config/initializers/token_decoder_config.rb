# The hmac_secret is used in token encoding and decoding
# when messages are sent between evo/dms
# This secret is maintained in the api_keys file, so is
# part of the APP_CONFIG in each application.
# If this gem is used in an app that does not use APP_CONFIG
# or does not have an hmac_secret defined, the class variable
# is not set and intra-app communication is disabled.
if defined?(APP_CONFIG) && APP_CONFIG.try(:[], "hmac_secret")
  TokenDecoder::Decoder.hmac_secret = APP_CONFIG["hmac_secret"]
end
