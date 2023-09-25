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
        content: %{
          "blocks" => [
            %{
              "data" => %{"level" => 3, "text" => Faker.Lorem.sentence(2)},
              "id" => "1",
              "type" => "header"
            },
            %{
              "data" => %{
                "caption" => "",
                "stretched" => false,
                "url" => "https://picsum.photos/seed/#{Faker.Lorem.characters(5)}/800/200",
                "withBackground" => false,
                "withBorder" => false
              },
              "id" => "2",
              "type" => "simpleImage"
            },
            %{
              "data" => %{
                "text" => Faker.Lorem.paragraphs(Enum.random(2..10))
              },
              "id" => "3",
              "type" => "paragraph"
            }
          ],
          "time" => System.os_time(),
          "version" => "2.28.0"
        },
        publish_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 1, :second),
        organization_id: Enum.random(organizations).id
      }
      |> Organizations.create_announcement()
    end
  end
end

Atomic.Repo.Seeds.Announcements.run()
