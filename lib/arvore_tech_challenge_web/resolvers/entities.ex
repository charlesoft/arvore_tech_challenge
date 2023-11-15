defmodule ArvoreTechChallengeWeb.Resolvers.Entities do
  @moduledoc """
  Resolver for entity data
  """

  alias ArvoreTechChallenge.Entities
  alias ArvoreTechChallenge.Entities.Entity

  import ArvoreTechChallengeWeb.ErrorHelper

  def list_entities(_parent, _args, _resolution) do
    {:ok, Entities.list_entities()}
  end

  def get_entity(_parent, %{id: id}, _resolution) do
    {:ok, Entities.get_entity_and_its_children(id)}
  end

  def create_entity(_parent, args, _resolution) do
    case Entities.create_entity(args) do
      {:ok, entity} ->
        entity = Entities.get_entity_and_its_children(entity.id)

        {:ok, entity}

      {:error, error} ->
        error_messages(error)
    end
  end

  def update_entity(_parent, %{id: id} = args, _resolution) do
    with {:ok, %Entity{} = entity} <- {:ok, find_entity(id)} do
      case Entities.update_entity(entity, args) do
        {:ok, entity} ->
          entity = Entities.get_entity_and_its_children(entity.id)

          {:ok, entity}

        {:error, error} ->
          error_messages(error)
      end
    else
      _ ->
        not_found_error()
    end
  end

  def delete_entity(_parent, %{id: id}, _resolution) do
    with {:ok, %Entity{} = entity} <- {:ok, find_entity(id)} do
      case Entities.delete_entity(entity) do
        {:ok, _entity} ->
          {:ok, %{message: "Entity and its children deleted with success."}}

        {:error, error} ->
          error_messages(error)
      end
    else
      _ ->
        not_found_error()
    end
  end

  defp find_entity(id) do
    Entities.get_entity(id)
  end
end
