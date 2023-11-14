defmodule ArvoreTechChallengeWeb.UserSchema do
  @moduledoc """
  Schema responsible for defining the User queries
  """
  use Absinthe.Schema

  import_types(ArvoreTechChallengeWeb.Schema.UserTypes)

  alias ArvoreTechChallengeWeb.Resolvers
  alias ArvoreTechChallengeWeb.Authentication

  query do
    @desc "Get user info"
    field :user, non_null(:user) do
      middleware(Authentication)
      resolve(&Resolvers.Accounts.get_user/3)
    end
  end

  mutation do
    @desc "Register user account"
    field :create_user, type: :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end

    @desc "Sign in user"
    field :sign_in, type: :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Accounts.sign_in/3)
    end
  end
end
