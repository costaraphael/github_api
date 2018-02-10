defmodule GithubApi.HttpAdapter.TestAdapter do
  @behaviour GithubApi.HttpAdapter
  
  def request(_url) do
    {:ok, %{body: "[]"}}
  end
end