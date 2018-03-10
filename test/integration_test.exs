defmodule GithubApi.IntegrationTest do
  use ExUnit.Case, async: false

  alias GithubApi.{SearchRepos, Issues, HttpAdapter.GithubAdapter}

  @moduletag :integration_tests

  setup_all do
    old_adapter = Application.get_env(:github_api, :http_adapter)
    Application.put_env(:github_api, :http_adapter, GithubAdapter)

    on_exit(fn ->
      Application.put_env(:github_api, :http_adapter, old_adapter)
    end)
  end

  test "search repos" do
    {:ok, result} =
      SearchRepos.init()
      |> SearchRepos.with_org("elixir-lang")
      |> SearchRepos.with_language("elixir")
      |> SearchRepos.with_term("flow")
      |> GithubApi.exec()

    assert Enum.any?(result.items, &(&1["name"] == "flow"))
    assert is_integer(result.total_count)
    assert result.total_count > 0
  end

  test "list issues" do
    {:ok, result} =
      Issues.init("elixir-lang", "elixir")
      |> Issues.only_closed()
      |> Issues.with_author("josevalim")
      |> GithubApi.exec()

    assert Enum.all?(result.items, &(&1["user"]["login"] == "josevalim"))

    assert is_integer(result.total_pages)
    assert result.total_pages > 0
  end
end
