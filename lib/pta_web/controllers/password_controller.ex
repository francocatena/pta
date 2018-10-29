defmodule PtaWeb.PasswordController do
  use PtaWeb, :controller

  alias Pta.Accounts
  alias Pta.Accounts.{Password, User}

  action_fallback PtaWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email}}) do
    case Accounts.get_user(email: email) do
      %User{} = user ->
        with {:ok, _} <- Password.reset(user) do
          message = dgettext("passwords", "Password reset instructions sent")

          conn
          |> put_status(:created)
          |> render("show.json", response: %{style: :info, message: message})
        end

      nil ->
        message = dgettext("passwords", "Email not found")

        conn
        |> put_status(:not_found)
        |> render("show.json", response: %{style: :error, message: message})
    end
  end

  def update(conn, %{"id" => token, "user" => password_params}) do
    case Accounts.get_user(token: token) do
      %User{} = user ->
        with {:ok, _} <- Accounts.update_user_password(user, password_params) do
          message = dgettext("passwords", "Password updated successfully")

          render(conn, "show.json", response: %{style: :info, message: message})
        end

      nil ->
        message = dgettext("passwords", "Token invalid or expired")

        conn
        |> put_status(:not_found)
        |> render("show.json", response: %{style: :error, message: message})
    end
  end
end
