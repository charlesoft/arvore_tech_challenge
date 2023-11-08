import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :arvore_tech_challenge, ArvoreTechChallenge.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "arvore_tech_challenge_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :arvore_tech_challenge, ArvoreTechChallengeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cbmTiRfZh+jwNulC9/hKKlKZR6YJnJNzoOncEANnXQdyM9M/OyKNjmwwv+3PqrWY",
  server: false

# In test we don't send emails.
config :arvore_tech_challenge, ArvoreTechChallenge.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
