defmodule Pta.Guardian do
  use Guardian, otp_app: :pta

  alias Pta.Accounts
  alias Pta.Accounts.Session

  def subject_for_token(%Session{} = session, _claims) do
    sub = %{
      account_id: session.account.id,
      user_id: session.user.id
    }

    {:ok, sub}
  end

  def subject_for_token(_, _), do: {:error, :wrong_subject}

  def resource_from_claims(%{} = claims) do
    %{"account_id" => account_id, "user_id" => user_id} = claims["sub"]
    resource = Accounts.get_current_session(account_id, user_id)

    {:ok, resource}
  end

  def resource_from_claims(_claims), do: {:error, :wrong_claim}
end
