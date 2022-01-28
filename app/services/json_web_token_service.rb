class JsonWebTokenService
  SECRET_KEY_BASE = Rails.application.secrets.secret_key_base.freeze

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY_BASE)
  end

  def self.decode(token)
    Rails.logger.info "Token before being decoded>>>#{token}"
    decoded = JWT.decode(token, SECRET_KEY_BASE)[0]
    Rails.logger.info "Decoded>>>>#{decoded}"
    HashWithIndifferentAccess.new decoded
  end
end
