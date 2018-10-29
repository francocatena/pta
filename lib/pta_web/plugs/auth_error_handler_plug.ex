defmodule PtaWeb.AuthErrorHandlerPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [json: 2]

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_status(:unauthorized)
    |> json(%{error: type})
  end
end
