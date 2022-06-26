defmodule MetricsUi.Datasources do
  use Tesla
  alias MetricsUi.Datasources.Github

  plug MetricsUi.DecodeJsonAs

  def get_star_count() do
    case Github.get_repo(%{user_id: 'facebook', repo_id: 'react'}) do
      {:ok, data} -> data
        |> Map.get("stargazers_count")
      {:error, _idc} -> "User not found."
    end
  end
end

defmodule MetricsUi.Structs.GithubRepo do
  defstruct stargazers_count: 0
end

defmodule MetricsUi.Datasources.Github do
  use Tesla
  require Logger
  alias MetricsUi.Structs.GithubRepo

  plug Tesla.Middleware.BaseUrl, "https://api.github.com"
  plug Tesla.Middleware.Headers, [{"user-agent", "Tesla"}]

  plug Tesla.Middleware.Headers, [
    {"authorization",
     "token " <> Application.get_env(:metrics_ui, MetricsUi.Secrets)[:github_token]}
  ]

  # plug Tesla.Middleware.JSON

  plug Tesla.Middleware.EncodeJson
  plug MetricsUi.Middleware.DecodeJsonAs

  @spec get_repo(%{user_id: String.t(), repo_id: String.t()}) :: {:ok, MetricsUi.SGithubUser} | {:error, any}
  def get_repo(%{user_id: user_id, repo_id: repo_id}) do
    get("/repos/#{user_id}/#{repo_id}")
  end

  def get_repo_gazers(%{user_id: user_id, repo_id: repo_id}) do
    get("/repos/#{user_id}/#{repo_id}/stargazers", decode_as: %GithubRepo{stargazers_count: 0})
  end
end
