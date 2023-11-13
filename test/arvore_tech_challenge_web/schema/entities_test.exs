defmodule ArvoreTechChallengeWeb.Schema.EntitiesTest do
  use ArvoreTechChallengeWeb.ConnCase

  alias ArvoreTechChallenge.Accounts.Guardian
  alias ArvoreTechChallenge.Entities.Entity
  alias ArvoreTechChallenge.Repo

  import ArvoreTechChallenge.Factory

  describe "entities query" do
    setup %{conn: conn} do
      user = insert!(:user, email: "test@example.com", password: "1234567")

      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, jwt: jwt}
    end

    @entities_query """
    query{
      entities{
        id
        name
        parent_id: parentId
        entity_type: entity_type
        inep
        subtree_ids: entities
      }
    }
    """

    test "returns a list of entities", %{conn: conn, jwt: jwt} do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity, name: "School Example", entity_type: :school, parent_id: network_id)

      %{id: class_id} =
        _class =
        insert!(:entity, name: "Class Example", entity_type: :class, parent_id: school_id)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities", query: @entities_query)

      assert json_response(conn, 200) == %{
               "data" => %{
                 "entities" => [
                   %{
                     "id" => "#{network_id}",
                     "name" => "Network Example",
                     "entity_type" => "network",
                     "inep" => nil,
                     "parent_id" => nil,
                     "subtree_ids" => ["#{school_id}"]
                   },
                   %{
                     "id" => "#{school_id}",
                     "name" => "School Example",
                     "entity_type" => "school",
                     "inep" => nil,
                     "parent_id" => "#{network_id}",
                     "subtree_ids" => ["#{class_id}"]
                   },
                   %{
                     "id" => "#{class_id}",
                     "name" => "Class Example",
                     "entity_type" => "class",
                     "inep" => nil,
                     "parent_id" => "#{school_id}",
                     "subtree_ids" => []
                   }
                 ]
               }
             }
    end

    test "returns unauthenticated if invalid access token key is given", %{conn: conn} do
      invalid_access_token_key = "invalid_access_token_key"

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_access_token_key}")
        |> post("/api/v2/partners/entities", query: @entities_query)

      assert %{"data" => %{"entities" => nil}, "errors" => [%{"message" => "unauthenticated"}]} =
               json_response(conn, 200)
    end
  end

  describe "query entity" do
    setup %{conn: conn} do
      user = insert!(:user, email: "test@example.com", password: "1234567")

      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, jwt: jwt}
    end

    @entity_query """
    query($id: ID!){
      entity(id: $id){
        id
        name
        parent_id: parentId
        entity_type: entity_type
        inep
        subtree_ids: entities
      }
    }
    """

    test "returns the entity for the given ID", %{conn: conn, jwt: jwt} do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity, name: "School Example", entity_type: :school, parent_id: network_id)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities", query: @entity_query, variables: %{id: network_id})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "entity" => %{
                   "id" => "#{network_id}",
                   "name" => "Network Example",
                   "entity_type" => "network",
                   "inep" => nil,
                   "parent_id" => nil,
                   "subtree_ids" => ["#{school_id}"]
                 }
               }
             }
    end

    test "returns nil if no entity is found by the given ID", %{conn: conn, jwt: jwt} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities", query: @entity_query, variables: %{id: 1})

      assert json_response(conn, 200) == %{
               "data" => %{
                 "entity" => nil
               }
             }
    end

    test "returns unauthenticated if invalid access token key is given", %{conn: conn} do
      invalid_access_token_key = "invalid_access_token_key"

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_access_token_key}")
        |> post("/api/v2/partners/entities", query: @entity_query, variables: %{id: 1})

      assert %{"data" => %{"entity" => nil}, "errors" => [%{"message" => "unauthenticated"}]} =
               json_response(conn, 200)
    end
  end

  describe "create entity mudation" do
    setup %{conn: conn} do
      user = insert!(:user, email: "test@example.com", password: "1234567")

      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, jwt: jwt}
    end

    @create_entity_mutation """
    mutation CreateEntity($name: String!, $entity_type: String!, $inep: String, $parent_id: String){
      createEntity(name: $name, entity_type: $entity_type, inep: $inep, parent_id: $parent_id){
        id
        name
        parent_id: parentId
        entity_type: entity_type
        inep
        subtree_ids: entities
      }
    }
    """

    test "creates an entity", %{conn: conn, jwt: jwt} do
      variables = %{
        name: "School Example",
        entity_type: "school",
        inep: "12345768",
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities", query: @create_entity_mutation, variables: variables)

      assert %{
               "data" => %{
                 "createEntity" => %{
                   "id" => id,
                   "name" => "School Example",
                   "entity_type" => "school",
                   "inep" => "12345768",
                   "parent_id" => nil,
                   "subtree_ids" => []
                 }
               }
             } = json_response(conn, 200)

      refute is_nil(id)
    end

    test "returns errors if given invalid data", %{conn: conn, jwt: jwt} do
      variables = %{
        name: "Class Example",
        entity_type: "class",
        inep: nil,
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities", query: @create_entity_mutation, variables: variables)

      assert %{
               "data" => %{"createEntity" => nil},
               "errors" => [
                 %{
                   "message" => ["parent_id required for entity_type 'class'"]
                 }
               ]
             } = json_response(conn, 200)
    end

    test "returns unauthenticated if invalid access token key is given", %{conn: conn} do
      invalid_access_token_key = "invalid_access_token_key"

      variables = %{
        name: "Class Example",
        entity_type: "class",
        inep: nil,
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_access_token_key}")
        |> post("/api/v2/partners/entities", query: @create_entity_mutation, variables: variables)

      assert %{
               "data" => %{"createEntity" => nil},
               "errors" => [%{"message" => "unauthenticated"}]
             } = json_response(conn, 200)
    end
  end

  describe "update entity mutation" do
    setup %{conn: conn} do
      user = insert!(:user, email: "test@example.com", password: "1234567")

      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, jwt: jwt}
    end

    @update_entity_mutation """
    mutation UpdateEntity($id: ID!, $name: String!, $entity_type: String!, $inep: String, $parent_id: String){
      updateEntity(id: $id, name: $name, entity_type: $entity_type, inep: $inep, parent_id: $parent_id){
        id
        name
        parent_id: parentId
        entity_type: entity_type
        inep
        subtree_ids: entities
      }
    }
    """

    test "update an entity", %{conn: conn, jwt: jwt} do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity,
          name: "School Example",
          entity_type: :school,
          inep: "555555",
          parent_id: network_id
        )

      update_variables = %{
        id: school_id,
        name: "New School",
        entity_type: "school",
        inep: "1234563745",
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities",
          query: @update_entity_mutation,
          variables: update_variables
        )

      assert json_response(conn, 200) == %{
               "data" => %{
                 "updateEntity" => %{
                   "id" => "#{school_id}",
                   "name" => "New School",
                   "entity_type" => "school",
                   "inep" => "1234563745",
                   "parent_id" => nil,
                   "subtree_ids" => []
                 }
               }
             }
    end

    test "returns 'Entity Not Found' error message if the entity does not exist for the given ID",
         %{conn: conn, jwt: jwt} do
      update_variables = %{
        id: 2,
        name: "New School",
        entity_type: "school",
        inep: "1234563745",
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities",
          query: @update_entity_mutation,
          variables: update_variables
        )

      assert %{
               "data" => %{"updateEntity" => nil},
               "errors" => [%{"message" => "Entity Not Found"}]
             } = json_response(conn, 200)
    end

    test "returns validation errors if given invalid data", %{conn: conn, jwt: jwt} do
      %{id: school_id} =
        _school =
        insert!(:entity,
          name: "School Example",
          entity_type: :school,
          inep: "555555",
          parent_id: nil
        )

      update_variables = %{
        id: school_id,
        name: "school",
        entity_type: "invalid_type",
        inep: "1234563745"
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities",
          query: @update_entity_mutation,
          variables: update_variables
        )

      assert %{
               "data" => %{"updateEntity" => nil},
               "errors" => [
                 %{
                   "message" => ["entity_type is invalid"]
                 }
               ]
             } = json_response(conn, 200)
    end

    test "returns unauthenticated if invalid access token key is given", %{conn: conn} do
      invalid_access_token_key = "invalid_access_token_key"

      update_variables = %{
        id: 1,
        name: "Class Example",
        entity_type: "class",
        inep: nil,
        parent_id: nil
      }

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{invalid_access_token_key}")
        |> post("/api/v2/partners/entities",
          query: @update_entity_mutation,
          variables: update_variables
        )

      assert %{
               "data" => %{"updateEntity" => nil},
               "errors" => [%{"message" => "unauthenticated"}]
             } = json_response(conn, 200)
    end
  end

  describe "delete entity mutation" do
    setup %{conn: conn} do
      user = insert!(:user, email: "test@example.com", password: "1234567")

      {:ok, jwt, _claims} = Guardian.encode_and_sign(user)

      {:ok, conn: conn, jwt: jwt}
    end

    @delete_entity_mutation """
    mutation DeleteEntity($id: ID!){
      deleteEntity(id: $id){
        message
      }
    }
    """

    test "deletes an entity and its children for the given ID", %{conn: conn, jwt: jwt} do
      %{id: network_id} =
        _network = insert!(:entity, name: "Network Example", entity_type: :network)

      %{id: school_id} =
        _school =
        insert!(:entity,
          name: "School Example",
          entity_type: :school,
          inep: "555555",
          parent_id: network_id
        )

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities",
          query: @delete_entity_mutation,
          variables: %{id: network_id}
        )

      assert %{
               "data" => %{
                 "deleteEntity" => %{
                   "message" => "Entity and its children deleted with success."
                 }
               }
             } = json_response(conn, 200)

      assert is_nil(Repo.get(Entity, network_id))
      assert is_nil(Repo.get(Entity, school_id))
    end

    test "returns 'Entity Not Found' error message if the entity does not exist for the given ID",
         %{conn: conn, jwt: jwt} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> post("/api/v2/partners/entities",
          query: @delete_entity_mutation,
          variables: %{id: 1}
        )

      assert %{
               "data" => %{"deleteEntity" => nil},
               "errors" => [%{"message" => "Entity Not Found"}]
             } = json_response(conn, 200)
    end
  end
end
