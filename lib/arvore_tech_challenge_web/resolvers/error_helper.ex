defmodule ArvoreTechChallengeWeb.ErrorHelper do
  @moduledoc """
  Module responsible for defining helpers to build error messages
  """

  def changeset_error_messages(error) do
    messages =
      Enum.map(error.errors, fn error ->
        {value, {message, _validation}} = error
        "#{value} #{message}"
      end)

    {:error, %{message: messages}}
  end

  def not_found_error do
    {:error, %{message: "Entity Not Found"}}
  end
end
