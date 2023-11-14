defmodule ArvoreTechChallengeWeb.Resolvers.Accounts do
  @moduledoc """
  Resolver for user data
  """

  alias ArvoreTechChallenge.Accounts
  alias ArvoreTechChallenge.Accounts.UserAuthenticator

  import ArvoreTechChallengeWeb.ErrorHelper

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
end
