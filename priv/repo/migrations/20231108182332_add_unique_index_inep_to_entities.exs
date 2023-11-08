defmodule ArvoreTechChallenge.Repo.Migrations.AddUniqueIndexInepToEntities do
  use Ecto.Migration

  def change do
    create unique_index(:entities, :inep)
  end
end
