defmodule ArvoreTechChallenge.Accounts do
  @moduledoc """
  Context module for users
  """
  alias ArvoreTechChallenge.Accounts.User
  alias ArvoreTechChallenge.Repo

  import Ecto.Query

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by_email(email) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
