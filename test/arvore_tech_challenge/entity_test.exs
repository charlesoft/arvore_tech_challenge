defmodule ArvoreTechChallenge.EntityTest do
  use ArvoreTechChallenge.DataCase

  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Repo

  describe "changeset/2" do
    test "creates a valid changeset" do
      attrs = %{
        name: "School Example",
        inep: "1232322",
        entity_type: :school,
        parent_id: nil
      }

      changeset = Entity.changeset(%Entity{}, attrs)

      assert changeset.valid?
    end

    test "creates and invalid changeset" do
      attrs = %{
        name: nil,
        inep: "1232322",
        entity_type: :school,
        parent_id: nil
      }

      changeset = Entity.changeset(%Entity{}, attrs)

      refute changeset.valid?

      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "inep should be set only for entity_type 'school'" do
      attrs = %{
        name: "Network Example",
        inep: "1232322",
        entity_type: :network,
        parent_id: nil
      }

      changeset = Entity.changeset(%Entity{}, attrs)
      {:error, changeset} = Repo.insert(changeset)

      refute changeset.valid?

      assert %{inep: ["can be only set for entity_type 'school'"]} = errors_on(changeset)
    end

    test "parent_id is required only for entity_type class" do
      valid_attrs = %{
        name: "School Example",
        inep: nil,
        entity_type: :network,
        parent_id: nil
      }

      valid_changeset = Entity.changeset(%Entity{}, valid_attrs)
      {:ok, _entity} = Repo.insert(valid_changeset)

      invalid_attrs = %{
        name: "Class Example",
        inep: nil,
        entity_type: :class,
        parent_id: nil
      }

      invalid_changeset = Entity.changeset(%Entity{}, invalid_attrs)
      {:error, changeset} = Repo.insert(invalid_changeset)

      refute changeset.valid?
      assert %{parent_id: ["required for entity_type 'class'"]} = errors_on(changeset)
    end
  end
end
