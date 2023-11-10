defmodule ArvoreTechChallenge.Entities.Entity do
  @moduledoc """
  Entity model
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias ArvoreTechChallenge.Entities.Entity

  @entity_types [:network, :school, :class]

  schema "entities" do
    field :name, :string
    field :entity_type, Ecto.Enum, values: @entity_types, default: :network
    field :inep, :string

    belongs_to :entity, Entity, foreign_key: :parent_id
    has_many :entities, Entity, foreign_key: :parent_id

    timestamps()
  end

  def changeset(entity, attrs \\ %{}) do
    entity
    |> cast(attrs, [:name, :entity_type, :inep, :parent_id])
    |> validate_required([:name, :entity_type])
    |> check_constraint(:inep,
      name: :inep_only_for_school,
      message: "can be only set for entity_type 'school'"
    )
    |> check_constraint(:parent_id,
      name: :parent_id_only_for_lower_relation,
      message: "required for entity_type 'class'"
    )
  end
end
