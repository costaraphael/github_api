defmodule GithubApi.Issues do
  @enforce_keys [:owner, :repo]
  defstruct params: %{}, owner: nil, repo: nil

  alias GithubApi.Issues

  def init(owner, repo) do
    %Issues{owner: owner, repo: repo}
  end

  def only_closed(request) do
    put_in(request.params[:state], "closed")
  end

  def any_status(request) do
    put_in(request.params[:state], "all")
  end

  def with_author(request, username) do
    put_in(request.params[:creator], username)
  end

  defimpl GithubApi.Request do
    def request_path(%{owner: owner, repo: repo}), do: "/repos/#{owner}/#{repo}/issues"
    def build_query(%{params: params}), do: URI.encode_query(params)

    def parse_response(_request, response) do
      {:ok, decoded} = Poison.decode(response.body)

      %{
        items: decoded,
        total_pages: find_last_page(response)
      }
    end

    defp find_last_page(response) do
      {_, value} = Enum.find(response.headers, fn {h, _v} -> h == "Link" end)

      value
      |> String.split(",")
      |> Enum.at(1)
      |> String.split(";")
      |> Enum.at(0)
      |> String.trim_leading(" <")
      |> String.trim_trailing(">")
      |> URI.parse()
      |> Map.get(:query)
      |> URI.decode_query()
      |> Map.get("page")
      |> String.to_integer()
    end
  end
end
