defmodule PtaWeb.AuthPlug do
  use Guardian.Plug.Pipeline,
    otp_app: :pta,
    module: Pta.Guardian,
    error_handler: PtaWeb.AuthErrorHandlerPlug

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
