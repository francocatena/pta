defmodule PtaWeb.Router do
  use PtaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug PtaWeb.AuthPlug
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  # TODO: find a better way to share between front end
  scope "/", PtaWeb do
    resources "/passwords", PasswordController, only: [:edit]
  end

  scope "/api/v1", PtaWeb do
    pipe_through :api

    resources "/sessions", SessionController, only: [:create], singleton: true
    resources "/passwords", PasswordController, only: [:create, :update]
  end

  scope "/api/v1", PtaWeb do
    pipe_through [:api, :authenticated]

    resources "/sessions", SessionController, only: [:delete], singleton: true
    resources "/users", UserController
  end
end
