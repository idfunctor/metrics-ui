
defmodule MetricsUi.Middleware.DecodeJsonAs do
  # requires tesla >= 1.0.0

  @moduledoc """
  Decodes JSON response conveniently
  """

  alias Tesla.Env

  @behaviour Tesla.Middleware

  @impl Tesla.Middleware
  def call(env, next, _) do
    decode(Tesla.run(env, next), env.opts[:decode_as])
  end

  defp decode({:ok, %Env{status: status, body: body}}, as) when status in 200..299 do
    case body do
      "" ->
        {:ok, nil}

      body ->
        Poison.decode(body, as: as)
    end
  end

  defp decode({:ok, %Env{body: ""} = env}, _), do: {:error, %Env{env | body: %{}}}

  defp decode({:ok, %Env{body: body} = env}, _) do
    with {:ok, body} <- Poison.decode(body) do
      {:error, %Env{env | body: body}}
    end
  end

  defp decode(error, _), do: error
end
