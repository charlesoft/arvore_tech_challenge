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

  def get_entity(id) do
    Entity
    |> where([e], e.id == ^id)
    |> preload(^[entities: select_entities_ids()])
    |> Repo.one()
  end

  defp select_entities_ids do
    from ce in Entity, select: ce.id
  end

  def create_entity(attrs) do
    %Entity{}
    |> Entity.changeset(attrs)
    |> Repo.insert()
  end

  def update_entity(entity, attrs) do
    attrs = Map.delete(attrs, :id)

    entity
    |> Entity.changeset(attrs)
    |> Repo.update()
  end
end
