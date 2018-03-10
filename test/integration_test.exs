defmodule GithubApi.IntegrationTest do
  use ExUnit.Case, async: false

  alias GithubApi.SearchRepos

  @moduletag :integration_tests

  setup_all do
    old_adapter = Application.get_env(:github_api, :http_adapter)
    Application.put_env(:github_api, :http_adapter, GithubApi.HttpAdapter.GithubAdapter)

    on_exit(fn ->
      Application.put_env(:github_api, :http_adapter, old_adapter)
    end)
  end

  test "teste de integração API GitHub" do
    {:ok, result} =
      SearchRepos.init()
      |> SearchRepos.with_org("elixir-lang")
      |> SearchRepos.with_language("elixir")
      |> SearchRepos.with_term("flow")
      |> GithubApi.exec()

    assert Enum.any?(result.items, &(&1["name"] == "flow"))
  end
end
