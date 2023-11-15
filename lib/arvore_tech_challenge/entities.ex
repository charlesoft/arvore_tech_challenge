defmodule ArvoreTechChallenge.Entities do
  @moduledoc """
  Context module for entities
  """

  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Repo

  import Ecto.Query

  def list_entities do
    Entity
    |> join(:left, [pe], ce in Entity, on: pe.id == ce.parent_id)
    |> preload(^[entities: select_entities_ids()])
    |> Repo.all()
  end

  def get_entity_and_its_children(id) do
    Entity
    |> where([e], e.id == ^id)
    |> preload(^[entities: select_entities_ids()])
    |> Repo.one()
  end

  def get_entity(id) do
    Repo.get(Entity, id)
  end

  defp select_entities_ids do
    from ce in Entity, select: ce.id
  end

  def create_entity(attrs) do
    parent_id = Map.get(attrs, :parent_id)

    with :ok <- ensure_valid_parent_id(parent_id) do
      %Entity{}
      |> Entity.changeset(attrs)
      |> Repo.insert()
    end
  end

  def update_entity(entity, attrs) do
    parent_id = Map.get(attrs, :parent_id)
    attrs = Map.delete(attrs, :id)

    with :ok <- ensure_valid_parent_id(parent_id) do
      entity
      |> Entity.changeset(attrs)
      |> Repo.update()
    end
  end

  def delete_entity(entity) do
    Repo.delete(entity)
  end

  defp ensure_valid_parent_id(nil), do: :ok

  defp ensure_valid_parent_id(parent_id) do
    if Repo.get(Entity, parent_id) do
      :ok
    else
      {:error, "invalid parent_id"}
    end
  end
end
