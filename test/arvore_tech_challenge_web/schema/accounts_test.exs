defmodule ArvoreTechChallengeWeb.Schema.AccountsTest do
  # use ArvoreTechChallenge.DataCase
  use ArvoreTechChallengeWeb.ConnCase

  describe "user account mutation" do
    @create_user_mutation """
    mutation CreateUser($email: String!, $password: String!) {
      createUser(email: $email, password: $password) {
        id
        email
      }
    }
    """

    test "creates a user", %{conn: conn} do
      variables = %{
        email: "charles@email.com",
        password: "123456"
      }

      conn =
        post(conn, "/api/v2/partners/entities", query: @create_user_mutation, variables: variables)

      assert %{
               "data" => %{
                 "createUser" => %{
                   "id" => id,
                   "email" => "charles@email.com"
                 }
               }
             } = json_response(conn, 200)

      refute is_nil(id)
    end

    test "returns errors if there are invalid data", %{conn: conn} do
      variables = %{
        email: "charlesemail.com",
        password: "12356"
      }

      conn =
        post(conn, "/api/v2/partners/entities", query: @create_user_mutation, variables: variables)

      assert %{
               "data" => %{"createUser" => nil},
               "errors" => [
                 %{
                   "message" => [
                     "email has invalid format",
                     "password should be at least %{count} character(s)"
                   ]
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
