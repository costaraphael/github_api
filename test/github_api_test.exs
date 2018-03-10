defmodule GithubApiTest do
  use ExUnit.Case

  alias GithubApi.{Request, SearchRepos}

  defp extract_request(request) do
    path = Request.request_path(request)

    query =
      request
      |> Request.build_query()
      |> URI.decode_query()

    {path, query}
  end

  test "permite listar os repositórios públicos" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_term("elixir")

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "elixir"}
  end

  test "permite listar os repositórios de um usuário" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_user("costaraphael")

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "user:costaraphael"}
  end

  test "permite listar os repositórios de uma organização" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_org("elixir-lang")

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "org:elixir-lang"}
  end

  test "permite paginar os resultados" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_org("elixir-lang")
      |> SearchRepos.page(2)

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "org:elixir-lang", "page" => "2"}
  end

  test "permite filtrar por linguagem" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_language("elixir")

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "language:elixir"}
  end

  test "permite utilizar múltiplos filtros" do
    request =
      SearchRepos.init()
      |> SearchRepos.with_user("josevalim")
      |> SearchRepos.with_language("elixir")
      |> SearchRepos.with_term("supervisor")

    {path, query} = extract_request(request)
    assert path == "/search/repositories"
    assert query == %{"q" => "user:josevalim supervisor language:elixir"}
  end
end
