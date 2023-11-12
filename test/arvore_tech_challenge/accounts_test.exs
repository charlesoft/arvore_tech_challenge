defmodule ArvoreTechChallenge.AccountsTest do
  use ArvoreTechChallenge.DataCase

  import ArvoreTechChallenge.Factory

  alias ArvoreTechChallenge.Accounts
  alias ArvoreTechChallenge.Accounts.User

  describe "get_user_by_email/1" do
    test "returns the user by the given email" do
      %{id: user_id} = insert!(:user, email: "charles@gmail.com")

      assert %User{id: ^user_id, email: "charles@gmail.com"} =
               Accounts.get_user_by_email("charles@gmail.com")
    end
  end

  describe "create_user/1" do
    test "creates a user" do
      attrs = %{
        email: "charles@gmail.com",
        password: "123456"
      }

      {:ok, %User{email: "charles@gmail.com"}} = Accounts.create_user(attrs)
    end

    test "returns a changeset error if there are invalid attrs" do
      attrs = %{
        email: "charlesteste.com",
        password: "1256"
      }

      {:error, changeset} = Accounts.create_user(attrs)

      assert %{email: ["has invalid format"], password: ["should be at least 6 character(s)"]} =
               errors_on(changeset)
    end
  end
end
