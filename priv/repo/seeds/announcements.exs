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
        publish_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 1, :second),
        organization_id: Enum.random(organizations).id
      }
      |> Organizations.create_announcement()
    end
  end
end

Atomic.Repo.Seeds.Announcements.run()
