# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :realtime_server,
  generators: [timestamp_type: :utc_datetime]

# Configure the endpoint
config :realtime_server, RealtimeServerWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: RealtimeServerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RealtimeServer.PubSub,
  live_view: [signing_salt: "Rx2Ow3/W"]

# Configure the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :realtime_server, RealtimeServer.Mailer, adapter: Swoosh.Adapters.Local

# Configure Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :realtime_server, RealtimeServer.PubSub,
  adapter: Phoenix.PubSub.Redis,
  redis_url: System.get_env("REDIS_URL") || "redis://localhost:6379/0",
  pool_size: 5

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
