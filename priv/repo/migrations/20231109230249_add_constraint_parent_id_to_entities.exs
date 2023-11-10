defmodule ArvoreTechChallenge.Repo.Migrations.AddConstraintParentIdToEntities do
  use Ecto.Migration

  def change do
    create constraint(
             "entities",
             :parent_id_only_for_lower_relation,
             check: "(parent_id IS NOT NULL AND entity_type = 'class') OR entity_type != 'class'"
           )
  end
end
