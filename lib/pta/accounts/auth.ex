defmodule Pta.Accounts.Auth do
  alias Pta.Repo
  alias Pta.Accounts.{Session, User}

  import Ecto.Query, only: [from: 2]
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]

  @doc false
  def authenticate_by_email_and_password(email, password) do
    query = from(u in User, preload: [:account], where: [email: ^email])
    user = Repo.one(query)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, %Session{user: user, account: user.account}}

      true ->
        dummy_checkpw()
        {:error, :unauthorized}
    end
  end
end
