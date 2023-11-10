defmodule ArvoreTechChallengeWeb.Resolvers.Entities do
  @moduledoc """
  Resolver for entity data
  """

  alias ArvoreTechChallenge.Entities

  def list_entities(_parent, _args, _resolution) do
    {:ok, Entities.list_entities()}
  end

  def get_entity(_parent, %{id: id}, _resolution) do
    {:ok, Entities.get_entity(id)}
  end

  def create_entity(_parent, args, _resolution) do
    case Entities.create_entity(args) do
      {:ok, entity} ->
        entity = Entities.get_entity(entity.id)

        {:ok, entity}

      {:error, error} ->
        messages = error_messages(error)

        {:error, %{message: messages}}
    end
  end

  def update_entity(_parent, %{id: id} = args, _resolution) do
    with {:ok, entity} when not is_nil(entity) <- {:ok, Entities.get_entity!(id)} do
      case Entities.update_entity(entity, args) do
        {:ok, entity} ->
          entity = Entities.get_entity(entity.id)

          {:ok, entity}

        {:error, error} ->
          messages = error_messages(error)

          {:error, %{message: messages}}
      end
    else
      {:error, message: "Entity Not Found"}
    end
  end

  defp error_messages(error) do
    Enum.map(error.errors, fn error ->
      {value, {message, _validation}} = error
      "#{value} #{message}"
    end)
  end
end
