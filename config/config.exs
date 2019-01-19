# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pta,
  ecto_repos: [Pta.Repo]

# Configures the endpoint
config :pta, PtaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sRnEsfnMwdPf59VDywcHivzDcS7ZKt76Im0OpFgqEpwW/0Hxr+P6Ild8APyaHC3X",
  render_errors: [view: PtaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Pta.PubSub, adapter: Phoenix.PubSub.PG2]

# Gettext config
config :pta, PtaWeb.Gettext, default_locale: "es_AR"

# Ecto timestamps
config :pta, Pta.Repo, migration_timestamps: [type: :utc_datetime]

# PaperTrail config
config :paper_trail, repo: Pta.Repo

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason

# Guardian config
config :pta, Pta.Guardian,
  issuer: "pta",
  verify_issuer: true,
  ttl: {1, :week},
  secret_key: "YFJEVCPY114z/veeCF6dB3aTSkeANkMJPPWoUUiioMTzj+gxsPTQMqBKAS+dpG0+"

# CORS Plug config
config :cors_plug,
  origin: ["localhost", "www.vintock.com"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
