defmodule GithubApi do
  def exec(request) do
    path = GithubApi.Request.request_path(request)
    query = GithubApi.Request.build_query(request)

    request("#{path}?#{query}")
  end

  defp request(path) do
    base_url = Application.get_env(:github_api, :api_url)
    http_adapter = Application.get_env(:github_api, :http_adapter)

    url = base_url <> path

    {:ok, response} = http_adapter.request(url)

    {:ok, decoded} = Poison.decode(response.body)

    result = %{
      total_count: decoded["total_count"],
      items: decoded["items"]
    }

    {:ok, result}
  end
end
