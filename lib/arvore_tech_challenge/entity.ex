defmodule ArvoreTechChallenge.Entity do
  @moduledoc """
  Entity model
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias ArvoreTechChallenge.Entity

  @entity_types [:network, :school, :class]

  schema "entities" do
    field :name, :string
    field :entity_type, Ecto.Enum, values: @entity_types, default: :network
    field :inep, :string

    belongs_to :entity_id, Entity, foreign_key: :parent_id
    has_many :entities, Entity

    timestamps()
  end

  def changeset(entity, attrs \\ %{}) do
    entity
    |> cast(attrs, [:name, :entity_type, :inep, :parent_id])
    |> validate_required([:name, :entity_type])
    |> validate_parent_id_if_class()
    |> validate_presence_inep_if_school()
  end

  defp validate_parent_id_if_class(
         %Ecto.Changeset{changes: %{parent_id: nil, entity_type: "class"}} = changeset
       ) do
    add_error(changeset, :parent_id, "perent_id can't be nil for entity_type 'class'")
  end

  defp validate_parent_id_if_class(changeset), do: changeset

  defp validate_presence_inep_if_school(%Ecto.Changeset{changes: %{inep: nil}} = changeset) do
    changeset
  end

  defp validate_presence_inep_if_school(
         %Ecto.Changeset{changes: %{entity_type: entity_type}} = changeset
       )
       when entity_type != "school" do
    add_error(changeset, :inep, "inep can be only set for entity_type 'school'")
  end
end
