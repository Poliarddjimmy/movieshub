module AuthHelpers
  def generate_token(user)
    payload = { user_id: user.id, exp: 0.00833333.hours.from_now.to_i }
    JsonWebToken.sign(payload, key: Rails.application.secrets.secret_key_base)
  end
end

RSpec.configure do |config|
  config.include AuthHelpers
end
