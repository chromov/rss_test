# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inno_test,
  ecto_repos: [InnoTest.Repo]

# Configures the endpoint
config :inno_test, InnoTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HIX3r6a16U7mahXpA9jUS6MxKeURUSTECxo6LxHdgIDGmoB7ULiTOhBb2egfdjeH",
  render_errors: [view: InnoTestWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: InnoTest.PubSub,
  live_view: [signing_salt: "7Y4oYEAI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :inno_test,
  sync_interval: 1,
  sync_retries: 5

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
