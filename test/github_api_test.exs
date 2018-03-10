defmodule GithubApiTest do
  use ExUnit.Case

  alias GithubApi.{Request, SearchRepos, Issues}

  defp extract_request(request) do
    path = Request.request_path(request)

    query =
      request
      |> Request.build_query()
      |> URI.decode_query()

    {path, query}
  end

  describe "SearchRepos" do
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

  describe "Issues" do
    test "permite listar as issues de um repositório" do
      request = Issues.init("elixir-lang", "elixir")

      {path, query} = extract_request(request)
      assert path == "/repos/elixir-lang/elixir/issues"
      assert query == %{}
    end

    test "permite filtrar apenas as issues fechadas ou todas as issues" do
      base_request = Issues.init("elixir-lang", "elixir")

      {path, query} = base_request |> Issues.only_closed() |> extract_request()
      assert path == "/repos/elixir-lang/elixir/issues"
      assert query == %{"state" => "closed"}

      {path, query} = base_request |> Issues.any_status() |> extract_request()
      assert path == "/repos/elixir-lang/elixir/issues"
      assert query == %{"state" => "all"}
    end

    test "permite filtrar pelo autor da issue" do
      request =
        Issues.init("elixir-lang", "elixir")
        |> Issues.with_author("josevalim")

      {path, query} = extract_request(request)
      assert path == "/repos/elixir-lang/elixir/issues"
      assert query == %{"creator" => "josevalim"}
    end
  end
end
