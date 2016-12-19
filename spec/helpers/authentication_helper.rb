module AuthenticationHelper
  def get_with_token(path, params={}, headers={})
    headers.merge!('Authorization' => get_access_token)
    get path, params, headers
  end

  def post_with_token(path, params={}, headers={})
    headers.merge!('Authorization' => get_access_token)
    post path, params, headers
  end

  def put_with_token(path, params={}, headers={})
    headers.merge!('Authorization' => get_access_token)
    put path, params, headers
  end

  def get_access_token
    user = User.create!(email: 'test@test.com', name: 'test', password: 'test')
    JsonWebToken.encode(user_id: user.id)
  end

end
