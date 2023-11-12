defmodule ArvoreTechChallenge.Accounts.UserAuthenticator do
  @moduledoc """
  This module is responsible for isolating the logic to sign in/sign out users
  """

  alias ArvoreTechChallenge.Accounts
  alias ArvoreTechChallenge.Accounts.{Guardian, User}

  def authenticate(email, password) do
    with %User{} = user <- Accounts.get_user_by_email(email),
         true <- Argon2.verify_pass(password, user.password),
         {:ok, jwt, _claims} <- Guardian.encode_and_sign(user) do
      {:ok, %{access_token: jwt}}
    else
      _ ->
        {:error, "Incorrect email or password"}
    end
  end
end
