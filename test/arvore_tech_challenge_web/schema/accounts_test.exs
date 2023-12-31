defmodule ArvoreTechChallengeWeb.Schema.AccountsTest do
  use ArvoreTechChallengeWeb.ConnCase

  alias ArvoreTechChallenge.Accounts
  alias ArvoreTechChallenge.Accounts.Guardian

  describe "get user query" do
    @user_query """
    query{
      user{
        id
        email
      }
    }
    """

    test "returns the current user by its access token", %{conn: conn} do
      {:ok, user} = Accounts.create_user(%{email: "test@example.com", password: "1234567"})
      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/users", query: @user_query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "user" => %{
                   "id" => "#{user.id}",
                   "email" => "test@example.com"
                 }
               }
             }
    end

    test "returns 'unauthenticated' if given an invalid access token", %{conn: conn} do
      invalid_token = "invalid_token"

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_token}")
        |> post("/users", query: @user_query)

      assert %{"data" => nil, "errors" => [%{"message" => "unauthenticated"}]} =
               json_response(conn, 200)
    end
  end

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

      conn = post(conn, "/users", query: @create_user_mutation, variables: variables)

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

      conn = post(conn, "/users", query: @create_user_mutation, variables: variables)

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

  describe "sign in mutation" do
    @sign_in_mutation """
    mutation SignIn($email: String!, $password: String!) {
      signIn(email: $email, password: $password) {
        accessToken
      }
    }
    """

    test "signs ins and returns the access token key", %{conn: conn} do
      {:ok, _user} = Accounts.create_user(%{email: "charles@email.com", password: "12345678"})

      variables = %{
        email: "charles@email.com",
        password: "12345678"
      }

      conn = post(conn, "/users", query: @sign_in_mutation, variables: variables)

      %{
        "data" => %{
          "signIn" => %{
            "accessToken" => access_token
          }
        }
      } = json_response(conn, 200)

      refute is_nil(access_token)
    end

    test "returns errors if authentication fails", %{conn: conn} do
      # no user created

      variables = %{
        email: "charles@email.com",
        password: "12345678"
      }

      conn = post(conn, "/users", query: @sign_in_mutation, variables: variables)

      assert %{
               "data" => %{"signIn" => nil},
               "errors" => [
                 %{
                   "message" => "Incorrect email or password"
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
