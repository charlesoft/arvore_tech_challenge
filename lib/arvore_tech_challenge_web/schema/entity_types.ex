defmodule ArvoreTechChallengeWeb.Schema.EntityTypes do
  use Absinthe.Schema.Notation

  object :entity do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :entity_type, non_null(:string)
    field :parent_id, :id
    field :inep, :string
    field :entities, list_of(:id)
  end

  object :delete_message_entity do
    field :message, :string
  end
end
