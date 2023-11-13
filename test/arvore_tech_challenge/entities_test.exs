defmodule ArvoreTechChallenge.EntitiesTest do
  use ArvoreTechChallenge.DataCase

  import ArvoreTechChallenge.Factory

  alias ArvoreTechChallenge.Entities
  alias ArvoreTechChallenge.Entities.Entity

  describe "list_entities/0" do
    test "returns a list of entities" do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity, name: "School Example", entity_type: :school, parent_id: network_id)

      %{id: class_id} =
        _class =
        insert!(:entity, name: "Class Example", entity_type: :class, parent_id: school_id)

      assert [
               %Entity{
                 id: ^network_id,
                 name: "Network Example",
                 entity_type: :network,
                 parent_id: nil,
                 entities: [^school_id]
               },
               %Entity{
                 id: ^school_id,
                 name: "School Example",
                 entity_type: :school,
                 parent_id: ^network_id,
                 entities: [^class_id]
               },
               %Entity{
                 id: ^class_id,
                 name: "Class Example",
                 parent_id: ^school_id,
                 entity_type: :class,
                 entities: []
               }
             ] = Entities.list_entities()
    end
  end

  describe "get_entity_and_its_children/1" do
    test "returns an entity and its children(entities) by the given ID" do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity, name: "School Example", entity_type: :school, parent_id: network_id)

      assert %Entity{
               id: ^network_id,
               name: "Network Example",
               entity_type: :network,
               parent_id: nil,
               entities: [^school_id]
             } = Entities.get_entity_and_its_children(network_id)
    end
  end

  describe "get_entity/1" do
    test "returns an entity by the given ID" do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity, name: "School Example", entity_type: :school, parent_id: network_id)

      assert %Entity{
               id: ^school_id,
               name: "School Example",
               entity_type: :school,
               parent_id: ^network_id
             } = Entities.get_entity(school_id)
    end
  end

  describe "create_entity/1" do
    test "creates an entity" do
      attrs = %{
        name: "School Example",
        entity_type: "school",
        inep: "132322",
        parent_id: nil
      }

      assert {:ok,
              %Entity{
                name: "School Example",
                inep: "132322",
                entity_type: :school,
                parent_id: nil
              }} = Entities.create_entity(attrs)
    end

    test "returns a changeset error if there are invalid attrs" do
      attrs = %{
        name: "Class Example",
        entity_type: :class,
        inep: nil,
        parent_id: nil
      }

      {:error, changeset} = Entities.create_entity(attrs)

      assert %{parent_id: ["required for entity_type 'class'"]} = errors_on(changeset)
    end
  end

  describe "update_entity/2" do
    setup do
      school = insert!(:entity, name: "School Example", entity_type: :school)
      class = insert!(:entity, name: "Class Example", entity_type: :class, parent_id: school.id)

      {:ok, school: school, class: class}
    end

    test "updates an entity", %{school: %{id: school_id}, class: %{id: class_id} = class} do
      attrs = %{name: "Old Class"}

      {:ok, %Entity{id: ^class_id, name: "Old Class", parent_id: ^school_id}} =
        Entities.update_entity(class, attrs)
    end

    test "returns a changeset error if there are invalid attrs", %{class: class} do
      attrs = %{name: "Old Class", parent_id: nil}

      {:error, changeset} = Entities.update_entity(class, attrs)

      assert %{parent_id: ["required for entity_type 'class'"]} = errors_on(changeset)
    end

    test "returns changeset error if parent_id for entity_type 'class' is not a entity_type 'school'",
         %{school: school} do
      %{id: network_id} = insert!(:entity, name: "Network Example", entity_type: :network)
      attrs = %{name: "New Class", entity_type: :class, parent_id: network_id}

      {:error, changeset} = Entities.update_entity(school, attrs)

      assert %{parent_id: ["parent_id for entity_type 'class' must have entity_type 'school'"]} =
               errors_on(changeset)
    end
  end

  describe "delete_entity/1" do
    test "deletes the given entity" do
      school = insert!(:entity, name: "School Example", entity_type: :school)

      {:ok, _entity} = Entities.delete_entity(school)
    end
  end
end
