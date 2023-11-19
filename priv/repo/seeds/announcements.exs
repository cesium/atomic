defmodule Atomic.Repo.Seeds.Announcements do
  @moduledoc """
  Seeds the database with announcements.
  """
  alias Atomic.Organizations
  alias Atomic.Organizations.{Announcement, Organization}
  alias Atomic.Repo

  def run do
    case Repo.all(Announcement) do
      [] ->
        seed_announcements()

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end

  def seed_announcements do
    organizations = Repo.all(Organization)

    for _ <- 1..15 do
      %{
        title: Faker.Lorem.sentence(),
        description: Faker.Lorem.paragraph(),
        organization_id: Enum.random(organizations).id
      }
      |> Organizations.create_announcement(build_publish_at_date())
    end
  end

  defp build_publish_at_date do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(Enum.random(1..59), :minute)
  end
end

Atomic.Repo.Seeds.Announcements.run()
