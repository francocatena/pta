defmodule Pta.Accounts.Auth do
  alias Pta.Repo
  alias Pta.Accounts.{Session, User}

  import Ecto.Query, only: [from: 2]
  import Argon2, only: [verify_pass: 2, no_user_verify: 0]

  @doc false
  def authenticate_by_email_and_password(email, password) do
    query = from(u in User, preload: [:account], where: [email: ^email])
    user = Repo.one(query)

    cond do
      user && verify_pass(password, user.password_hash) ->
        {:ok, %Session{user: user, account: user.account}}

      true ->
        no_user_verify()
        {:error, :unauthorized}
    end
  end
end
