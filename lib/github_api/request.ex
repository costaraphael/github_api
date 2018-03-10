defprotocol GithubApi.Request do
  def request_path(request)

  def build_query(request)

  def parse_response(request, response)
end
