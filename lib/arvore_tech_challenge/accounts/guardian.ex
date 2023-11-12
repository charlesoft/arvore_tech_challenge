defmodule ArvoreTechChallenge.Accounts.Guardian do
  use Guardian, otp_app: :arvore_tech_challenge

  alias ArvoreTechChallenge.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  rescue
    Ecto.NoResultsError -> {:error, :user_not_found}
  end
end
