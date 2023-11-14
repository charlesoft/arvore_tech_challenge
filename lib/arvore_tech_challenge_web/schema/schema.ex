defmodule ArvoreTechChallengeWeb.Schema do
  use Absinthe.Schema

  import_types(ArvoreTechChallengeWeb.Schema.EntityTypes)

  alias ArvoreTechChallengeWeb.Resolvers
  alias ArvoreTechChallengeWeb.Authentication

  query do
    @desc "Get a list of entitites"
    field :entities, list_of(:entity) do
      middleware(Authentication)
      resolve(&Resolvers.Entities.list_entities/3)
    end

    @desc "Get an entity by ID"
    field :entity, :entity do
      arg(:id, non_null(:id))

      middleware(Authentication)
      resolve(&Resolvers.Entities.get_entity/3)
    end
  end

  mutation do
    @desc "Create an entity"
    field :create_entity, type: :entity do
      arg(:name, non_null(:string))
      arg(:entity_type, non_null(:string))
      arg(:inep, :string)
      arg(:parent_id, :string)

      middleware(Authentication)
      resolve(&Resolvers.Entities.create_entity/3)
    end

    @desc "Update an entity"
    field :update_entity, type: :entity do
      arg(:id, non_null(:id))
      arg(:name, :string)
      arg(:entity_type, :string)
      arg(:inep, :string)
      arg(:parent_id, :string)

      middleware(Authentication)
      resolve(&Resolvers.Entities.update_entity/3)
    end

    @desc "Delete an entity"
    field :delete_entity, type: :delete_message_entity do
      arg(:id, non_null(:id))

      middleware(Authentication)
      resolve(&Resolvers.Entities.delete_entity/3)
    end
  end
end
