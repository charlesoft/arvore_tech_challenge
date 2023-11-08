defmodule ArvoreTechChallenge.Repo.Migrations.CreateEntitiesTable do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :name, :string, null: false
      add :entity_type, :string, default: "network", null: false
      add :inep, :string

      add :parent_id, references(:entities, on_delete: :nothing)

      timestamps()
    end
  end
end
