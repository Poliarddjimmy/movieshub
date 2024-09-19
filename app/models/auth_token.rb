class AuthToken
  def self.key
    Rails.application.secrets.secret_key_base
  end

  def self.token(user)
    payload = { user_id: user.id, exp: 0.5.hours.from_now.to_i }
    JsonWebToken.sign(payload, key: key)
  end

  def self.verify(token)
    result = JsonWebToken.verify(token, key: key)
    return nil if result[:error]

    User.find_by(id: result[:ok]['user_id'])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def self.logout
    # JWTs are stateless; typical logout might involve changing the secret or token invalidation
    # Here, we return nil for simplicity
    nil
  end
end
