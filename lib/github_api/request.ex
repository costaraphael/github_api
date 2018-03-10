defmodule GithubApi.Request do
  def request_path(_request), do: "/search/repositories"

  def build_query(request) do
    request.params
    |> Enum.reduce(%{q: []}, fn {key, value}, acc ->
      case key do
        :term -> Map.update!(acc, :q, &[value | &1])
        :user -> Map.update!(acc, :q, &["user:#{value}" | &1])
        :org -> Map.update!(acc, :q, &["org:#{value}" | &1])
        :page -> Map.put(acc, :page, value)
        :language -> Map.update!(acc, :q, &["language:#{value}" | &1])
      end
    end)
    |> Map.update!(:q, &Enum.join(&1, " "))
    |> URI.encode_query()
  end
end
