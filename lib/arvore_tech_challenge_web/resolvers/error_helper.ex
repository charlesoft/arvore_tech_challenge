defmodule ArvoreTechChallengeWeb.ErrorHelper do
  @moduledoc """
  Module responsible for defining helpers to build error messages
  """

  def error_messages(%{errors: errors}) do
    messages =
      Enum.map(errors, fn error ->
        {value, {message, _validation}} = error
        "#{value} #{message}"
      end)

    {:error, %{message: messages}}
  end

  def error_messages(error) do
    {:error, %{message: error}}
  end

  def not_found_error do
    {:error, %{message: "Entity Not Found"}}
  end
end
