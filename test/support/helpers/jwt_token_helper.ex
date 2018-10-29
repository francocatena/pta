defmodule Pta.Support.JwtTokenHelper do
  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  import Pta.Support.FixtureHelper

  alias Pta.Accounts.Session

  using do
    quote do
      import Pta.Support.JwtTokenHelper

      setup %{conn: conn} = config do
        do_setup(conn, config[:login_as])
      end
    end
  end

  def do_setup(_, nil), do: :ok

  def do_setup(conn, email) do
    {:ok, user, account} = fixture(:user, %{email: email})
    session = %Session{account: account, user: user}
    {:ok, token, _claims} = Pta.Guardian.encode_and_sign(session)

    conn =
      conn
      |> put_req_header("authorization", "Bearer " <> token)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn, account: account, user: user}
  end
end
