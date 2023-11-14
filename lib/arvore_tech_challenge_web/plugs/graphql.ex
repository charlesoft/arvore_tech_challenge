defmodule ArvoreTechChallenge.GraphQL do
  use Plug.Builder

  plug(Absinthe.Plug, schema: ArvoreTechChallengeWeb.Schema)
end
