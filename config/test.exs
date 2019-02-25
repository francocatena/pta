use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pta, PtaWeb.Endpoint,
  http: [port: 4001],
  server: false

# Gettext config
config :pta, PtaWeb.Gettext, default_locale: "en"

# Bamboo test adapter
config :pta, Pta.Notifications.Mailer, adapter: Bamboo.TestAdapter

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pta, Pta.Repo,
  username: "postgres",
  password: "postgres",
  database: "pta_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir,
  t_cost: 1,
  m_cost: 5
