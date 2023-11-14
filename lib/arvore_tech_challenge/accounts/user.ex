defmodule ArvoreTechChallenge.Accounts.User do
  @moduledoc """
  User model
  """
  use Ecto.Schema
  import Ecto.Changeset

  @password_min_size 6
  @email_regex ~r/@/

  schema "users" do
    field :email, :string
    field :password, :string

    timestamps()
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: @password_min_size)
    |> validate_format(:email, @email_regex)
    |> unique_constraint(:email, name: :users_email_index, message: "should be unique")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
