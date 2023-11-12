defmodule ArvoreTechChallenge.Factory do
  @moduledoc """
  Fatory for building the structs to be used in tests
  """

  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Accounts.User
  alias ArvoreTechChallenge.Repo

  def insert!(factory_name, attributes \\ %{}) do
    factory_name
    |> build()
    |> struct!(attributes)
    |> Repo.insert!()
  end

  def build(:user) do
    %User{
      email: "example@email.com",
      password: "123456"
    }
  end

  def build(:entity) do
    %Entity{
      name: "Network example",
      entity_type: :network,
      inep: nil,
      parent_id: nil
    }
  end
end