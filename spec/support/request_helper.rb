module RequestHelper
  # Parse JSON response to ruby hash
  def json
    JSON.parse(response.body)
  end

  # Login helper method
  def login(email, password)
    post '/api/v1/login', params: { email:, password: }, as: :json
    @login_response = response
    @token = json['token']
  end
end
