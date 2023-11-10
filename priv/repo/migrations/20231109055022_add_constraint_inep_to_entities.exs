defmodule ArvoreTechChallenge.Repo.Migrations.AddConstraintInepToEntities do
  use Ecto.Migration

  def change do
    create constraint(
             "entities",
             :inep_only_for_school,
             check: "(inep IS NOT NULL AND entity_type = 'school') OR inep IS NULL"
           )
  end
end
