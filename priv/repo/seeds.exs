defmodule Atomic.Repo.Seeds do
  @moduledoc """
  Script for populating the database.
  You can run it as:
    $ mix run priv/repo/seeds.exs # or mix ecto.seed
  """
  @seeds_dir "priv/repo/seeds"

  def run do
    [
      "organizations.exs",
      "courses.exs",
      "accounts.exs",
      "feed.exs",
      "enrollments.exs",
      "departments.exs",
      "memberships.exs",
      "partners.exs",
      "speakers.exs"
    ]
    |> Enum.each(fn file ->
      Code.require_file("#{@seeds_dir}/#{file}")
    end)
  end
end

Atomic.Repo.Seeds.run()
