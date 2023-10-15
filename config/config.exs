# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :daakia,
  ecto_repos: [Daakia.Repo]

# Configures the endpoint
config :daakia, DaakiaWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: DaakiaWeb.ErrorHTML, json: DaakiaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Daakia.PubSub,
  live_view: [signing_salt: "+3zwtLDO"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :daakia, Daakia.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args: ~w( js/app.js
      --format=esm --minify --splitting
      --bundle --target=es2017 --outdir=../priv/static/assets
      --loader:.woff2=file
      --loader:.woff=file
      --loader:.ttf=file
      --loader:.eot=file
      --loader:.svg=file
      --external:/fonts/*
      --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

# Ash related config
config :daakia, ash_apis: [Daakia.Accounts, Daakia.Newsletters]

# config :ash, :validate_api_resource_inclusion?, false
# config :ash, :validate_api_config_inclusion?, false
config :ash, :use_all_identities_in_manage_relationship?, false
