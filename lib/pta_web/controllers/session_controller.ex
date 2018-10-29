defmodule PtaWeb.SessionController do
  use PtaWeb, :controller

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Pta.Accounts.authenticate_by_email_and_password(email, password) do
      {:ok, session} ->
        {:ok, token, _claims} = Pta.Guardian.encode_and_sign(session)

        conn
        |> put_status(:created)
        |> render("show.json", session: %{session: session, token: token})

      {:error, :unauthorized} ->
        message = dgettext("sessions", "Invalid email/password combination")

        conn
        |> put_status(:unauthorized)
        |> render("show.json", session: %{error: :unauthorized, message: message})
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.current_token()
    |> Pta.Guardian.revoke()

    send_resp(conn, :no_content, "")
  end
end
