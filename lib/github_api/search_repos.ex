defmodule GithubApi.SearchRepos do
  def init do
    %{params: %{}}
  end

  def with_term(request, term) do
    put_in(request.params[:term], term)
  end

  def with_user(request, user) do
    put_in(request.params[:user], user)
  end

  def with_org(request, org) do
    put_in(request.params[:org], org)
  end

  def with_language(request, language) do
    put_in(request.params[:language], language)
  end

  def page(request, page) do
    put_in(request.params[:page], page)
  end
end
