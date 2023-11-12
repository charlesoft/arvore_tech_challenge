defmodule ArvoreTechChallenge.UserTest do
  use ArvoreTechChallenge.DataCase

  alias ArvoreTechChallenge.Accounts.User

  describe "changeset/2" do
    test "creates a valid changeset" do
      attrs = %{
        email: "charles@email.com",
        password: "123456"
      }

      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid?
    end

    test "creates an invalid changeset" do
      attrs = %{
        email: nil,
        password: nil
      }

      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?

      assert %{email: ["can't be blank"], password: ["can't be blank"]} = errors_on(changeset)
    end

    test "validates email format and password length" do
      attrs = %{
        email: "invalid_email",
        password: "1234"
      }

      changeset = User.changeset(%User{}, attrs)

      refute changeset.valid?

      assert %{email: ["has invalid format"], password: ["should be at least 6 character(s)"]} =
               errors_on(changeset)
    end
  end
end
