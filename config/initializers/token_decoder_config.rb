return unless APP_CONFIG
return unless APP_CONFIG["hmac_secret"]
TokenDecoder::Decoder.hmac_secret = APP_CONFIG["hmac_secret"]
Rails.logger.info("****** TokenDecoder Ha sBeen Update")