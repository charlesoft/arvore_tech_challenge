defmodule ArvoreTechChallenge.EntityTest do
  use ArvoreTechChallenge.DataCase

  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Repo

  import ArvoreTechChallenge.Factory

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

    test "creates an invalid changeset" do
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
        name: "Class Example",
        inep: "1232322",
        entity_type: :class,
        parent_id: nil
      }

      changeset = Entity.changeset(%Entity{}, attrs)

      refute changeset.valid?

      assert %{inep: ["can be only set for entity_type 'school'"]} = errors_on(changeset)
    end

    test "checks correct parent_id if there are any for entity_type 'school'" do
      %{id: network_id} = insert!(:entity, entity_type: :network)
      %{id: school_id} = insert!(:entity, entity_type: :school, parent_id: network_id)

      # changeset to update
      %{id: class_id} = class = insert!(:entity, entity_type: :class, parent_id: school_id)

      attrs = %{
        entity_type: :school,
        parent_id: class_id
      }

      changeset = Entity.changeset(class, attrs)

      refute changeset.valid?

      assert %{parent_id: ["for entity_type 'school' must have entity_type 'network'"]} =
               errors_on(changeset)
    end

    test "runs db check constraint that parent_id is required for entity_type class" do
      valid_attrs = %{
        name: "School Example",
        inep: nil,
        entity_type: :school,
        parent_id: nil
      }

      valid_changeset = Entity.changeset(%Entity{}, valid_attrs)
      assert valid_changeset.valid?

      {:ok, _entity} = Repo.insert(valid_changeset)

      invalid_attrs = %{
        name: "Class Example",
        inep: nil,
        entity_type: :class,
        parent_id: nil
      }

      invalid_changeset = Entity.changeset(%Entity{}, invalid_attrs)
      assert invalid_changeset.valid?

      {:error, changeset} = Repo.insert(invalid_changeset)

      refute changeset.valid?
      assert %{parent_id: ["required for entity_type 'class'"]} = errors_on(changeset)
    end
  end
end
