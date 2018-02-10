defmodule GithubApi do
  def list_repos do
    request("/repositories")
  end

  def list_repos(%{user: user}) do
    request("/users/#{user}/repos")
  end

  def list_repos(%{org: org}) do
    request("/orgs/#{org}/repos")
  end

  defp request(path) do
    base_url = Application.get_env(:github_api, :api_url)
    http_adapter = Application.get_env(:github_api, :http_adapter)

    url = base_url <> path

    {:ok, response} = http_adapter.request(url)

    Poison.decode(response.body)
  end
end
