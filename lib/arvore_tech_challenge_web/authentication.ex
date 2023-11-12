defmodule ArvoreTechChallengeWeb.Authentication do
  @moduledoc """
  Middleware to athenticate user before queries/mutations
  """
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution

       _ ->
        Absinthe.Resolution.put_result(resolution, {:error, "unauthenticated"})
    end
  end
end