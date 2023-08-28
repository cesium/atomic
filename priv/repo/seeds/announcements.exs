defmodule Atomic.Repo.Seeds.Announcement do
  alias Atomic.Organizations.{Announcement, Organization}
  alias Atomic.Repo

  def run do
    seed_announcements()
  end

  def seed_announcements do
    case Repo.all(Announcement) do
      [] ->
        organizations = Repo.all(Organization)

        for organization <- organizations do
          for _ <- 1..10 do
            %Announcement{}
            |> Announcement.changeset(%{
              title: Faker.Lorem.sentence(),
              description: Faker.Lorem.paragraph(),
              publish_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 1, :minute),
              organization_id: organization.id
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end
end

Atomic.Repo.Seeds.Announcement.run()
