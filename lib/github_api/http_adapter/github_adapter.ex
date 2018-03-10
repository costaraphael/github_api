defmodule GithubApi.HttpAdapter.GithubAdapter do
  @moduledoc false

  @behaviour GithubApi.HttpAdapter

  def request(url) do
    HTTPoison.get(url)
  end
end
