# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :atomic,
  ecto_repos: [Atomic.Repo],
  generators: [binary_id: true],
  owner: %{
    name: "Atomic",
    time_zone: "Europe/Lisbon",
    day_start: 0,
    day_end: 24
  }

# Configures the endpoint
config :atomic, AtomicWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: AtomicWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Atomic.PubSub,
  live_view: [signing_salt: "DmLAlyrN"]

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: "priv",
  asset_host: {:system, "ASSET_HOST"}

config :flop,
  default_limit: 7,
  repo: Atomic.Repo

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :atomic, Atomic.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, Swoosh.ApiClient.Hackney

config :atomic, AtomicWeb.Gettext, default_locale: "pt", locales: ~w(en pt)

config :atomic, AtomicWeb.Endpoint, server: true

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tailwind,
  version: "3.2.7",
  default: [
    args: ~w(
    --config=tailwind.config.js
    --input=css/app.css
    --output=../priv/static/assets/app.css
  ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :icons,
  collection: [Heroicons, Ionicons]

config :atomic, Atomic.Scheduler,
  jobs: [
    # Runs every midnight:
    {"@daily", {Atomic.Quantum.CertificateDelivery, :send_certificates, []}}
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
