defmodule Atomic.Repo do
  use Ecto.Repo,
    otp_app: :atomic,
    adapter: Ecto.Adapters.Postgres
end
