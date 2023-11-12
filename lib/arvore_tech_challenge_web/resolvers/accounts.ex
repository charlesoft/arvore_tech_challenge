defmodule ArvoreTechChallengeWeb.Resolvers.Accounts do
  @moduledoc """
  Resolver for user data
  """

  alias ArvoreTechChallenge.Accounts
  alias ArvoreTechChallenge.Accounts.UserAuthenticator

  def create_user(_parent, args, _context) do
    case Accounts.create_user(args) do
      {:ok, account} ->
        {:ok, account}

      {:error, error} ->
        changeset_error_messages(error)
    end
  end

  def sign_in(_parents, %{email: email, password: password}, _context) do
    case UserAuthenticator.authenticate(email, password) do
      {:ok, token} ->
        {:ok, token}

        {:error, error} ->
          {:error, %{message: error}}
    end
  end

  defp changeset_error_messages(error) do
    messages =
      Enum.map(error.errors, fn error ->
        {value, {message, _validation}} = error
        "#{value} #{message}"
      end)

    {:error, %{message: messages}}
  end
end
