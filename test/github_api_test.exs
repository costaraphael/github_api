defmodule GithubApiTest do
  use ExUnit.Case

  test "permite listar os repositórios públicos" do
    assert {:ok, result} = GithubApi.search_repos(%{term: "elixir"})

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "elixir"}

    assert result.total_count
    assert is_list(result.items)
  end

  test "permite listar os repositórios de um usuário" do
    assert {:ok, result} = GithubApi.search_repos(%{user: "costaraphael"})

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "user:costaraphael"}

    assert result.total_count
    assert is_list(result.items)
  end

  test "permite listar os repositórios de uma organização" do
    assert {:ok, result} = GithubApi.search_repos(%{org: "elixir-lang"})

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "org:elixir-lang"}

    assert result.total_count
    assert is_list(result.items)
  end

  test "permite paginar os resultados" do
    assert {:ok, _result} = GithubApi.search_repos(%{org: "elixir-lang", page: 2})

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "org:elixir-lang", "page" => "2"}
  end

  test "permite filtrar por linguagem" do
    assert {:ok, _result} = GithubApi.search_repos(%{language: "elixir"})

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "language:elixir"}
  end

  test "permite utilizar múltiplos filtros" do
    assert {:ok, _result} = 
      GithubApi.search_repos(%{
        user: "josevalim",
        language: "elixir",
        term: "supervisor"
      })

    assert_received {:request_url, url}
    assert url.path == "/search/repositories"

    query = URI.decode_query(url.query)
    assert query == %{"q" => "user:josevalim supervisor language:elixir"}
  end
end
