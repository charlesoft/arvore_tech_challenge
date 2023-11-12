defmodule ArvoreTechChallengeWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation

  object :user do
    field(:id, non_null(:id))
    field(:email, non_null(:string))
  end

  object :session do
    field(:access_token, non_null(:string))
  end
end
