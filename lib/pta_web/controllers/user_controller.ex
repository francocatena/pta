defmodule PtaWeb.UserController do
  use PtaWeb, :controller

  alias Pta.Accounts
  alias Pta.Accounts.User

  action_fallback PtaWeb.FallbackController

  def action(conn, _) do
    session = Guardian.Plug.current_resource(conn)

    apply(__MODULE__, action_name(conn), [conn, conn.params, session])
  end

  def index(conn, params, session) do
    users = Accounts.list_users(session.account, params)

    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}, session) do
    with {:ok, %User{} = user} <- Accounts.create_user(session, user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}, session) do
    user = Accounts.get_user!(session.account, id)

    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}, session) do
    user = Accounts.get_user!(session.account, id)

    with {:ok, %User{} = user} <- Accounts.update_user(session, user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}, session) do
    user = Accounts.get_user!(session.account, id)

    with {:ok, %User{}} <- Accounts.delete_user(session, user) do
      send_resp(conn, :no_content, "")
    end
  end
end
