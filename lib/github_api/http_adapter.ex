defmodule GithubApi.HttpAdapter do
  @callback request(url :: String.t()) :: {:ok, %{body: String.t()}} | {:error, term}
end
