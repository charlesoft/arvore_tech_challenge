defmodule ArvoreTechChallengeWeb.Context do
  @moduledoc """
  Absinthe Context to authenticate user
  """
  @behaviour Plug

  import Plug.Conn

  alias ArvoreTechChallenge.Accounts.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, current_user} ->
        put_private(conn, :absinthe, %{context: %{current_user: current_user}})

      _ ->
        conn
    end
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user, _claims} <- Guardian.resource_from_token(token) do
      {:ok, current_user}
    end
  end
end
