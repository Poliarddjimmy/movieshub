class AuthToken
  def self.key
    Rails.application.secrets.secret_key_base
  end

  def self.token(user, exp = 0.5.hours.from_now.to_i)
    payload = { user_id: user.id, exp: exp }
    JsonWebToken.sign(payload, key: key)
  end

  def self.refresh_token(token)
    result = JsonWebToken.verify(token, key: key)

    return nil if result[:error]

    return nil if result[:ok][:exp] < Time.zone.now.to_i

   token(result[:ok][:user_id])
  end

  def self.verify(token)
    result = JsonWebToken.verify(token, key: key)

    return nil if result[:error]

    # check if token is expired
    return nil if Time.zone.now.to_i > result[:ok][:exp]

    User.find_by(id: result[:ok][:user_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def self.logout(token)
    Blacklist.create(token: token) if token
  end

  def self.token_valid?(token)
    !Blacklist.exists?(token: token)
  end
end
