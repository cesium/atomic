defmodule Atomic.Repo do
  use Ecto.Repo,
    otp_app: :atomic,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
