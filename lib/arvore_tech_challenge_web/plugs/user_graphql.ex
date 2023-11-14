defmodule ArvoreTechChallenge.UserGraphQL do
  use Plug.Builder

  plug(Absinthe.Plug, schema: ArvoreTechChallengeWeb.UserSchema)
end
