defmodule Atomic.Repo do
  use Ecto.Repo,
    otp_app: :atomic,
    adapter: Ecto.Adapters.Postgres

  use Paginator

  def count(query), do: aggregate(query, :count)
end
