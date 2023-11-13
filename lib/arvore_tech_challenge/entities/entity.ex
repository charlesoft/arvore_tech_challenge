defmodule ArvoreTechChallenge.Entities.Entity do
  @moduledoc """
  Entity model
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Repo

  @entity_types [:network, :school, :class]

  schema "entities" do
    field :name, :string
    field :entity_type, Ecto.Enum, values: @entity_types
    field :inep, :string

    belongs_to :entity, Entity, foreign_key: :parent_id
    has_many :entities, Entity, foreign_key: :parent_id

    timestamps()
  end

  def changeset(entity, attrs \\ %{}) do
    entity
    |> cast(attrs, [:name, :entity_type, :inep, :parent_id])
    |> validate_required([:name, :entity_type])
    |> validate_presence_of_parent_id()
    |> validate_inep_for_school()
    |> check_constraint(:parent_id,
      name: :parent_id_only_for_lower_relation,
      message: "required for entity_type 'class'"
    )
    |> check_constraint(:inep,
      name: :inep_only_for_school,
      message: "can be only set for entity_type 'school'"
    )
  end

  defp validate_presence_of_parent_id(
         %Ecto.Changeset{changes: %{parent_id: nil, entity_type: :class}} = changeset
       ) do
    add_error(changeset, :parent_id, "required for entity_type 'class'")
  end

  defp validate_presence_of_parent_id(
         %Ecto.Changeset{changes: %{parent_id: parent_id, entity_type: :class}} = changeset
       ) do
    unless Repo.get(Entity, parent_id).entity_type == :school do
      add_error(
        changeset,
        :parent_id,
        "parent_id for entity_type 'class' must have entity_type 'school'"
      )
    end
  end

  defp validate_presence_of_parent_id(
         %Ecto.Changeset{changes: %{parent_id: parent_id, entity_type: entity_type}} = changeset
       ) do
    unless Repo.get(Entity, parent_id).entity_type == :network do
      add_error(
        changeset,
        :parent_id,
        "parent_id for entity_type '#{entity_type}' must have entity_type 'network'"
      )
    end
  end

  defp validate_presence_of_parent_id(changeset), do: changeset

  defp validate_inep_for_school(%Ecto.Changeset{changes: %{inep: nil}} = changeset) do
    changeset
  end

  defp validate_inep_for_school(
         %Ecto.Changeset{changes: %{inep: _inep, entity_type: :school}} = changeset
       ) do
    changeset
  end

  defp validate_inep_for_school(
         %Ecto.Changeset{changes: %{inep: _inep, entity_type: _entity_type}} = changeset
       ) do
    add_error(changeset, :inep, "can be only set for entity_type 'school'")
  end

  defp validate_inep_for_school(changeset), do: changeset
end
