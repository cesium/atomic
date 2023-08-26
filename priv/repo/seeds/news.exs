defmodule Atomic.Repo.Seeds.News do
  alias Atomic.Organizations.{News, Organization}
  alias Atomic.Repo

  def run do
    seed_news()
  end

  def seed_news do
    case Repo.all(News) do
      [] ->
        organizations = Repo.all(Organization)

        for organization <- organizations do
          for _ <- 1..10 do
            %News{}
            |> News.changeset(%{
              title: Faker.Lorem.sentence(),
              description: Faker.Lorem.paragraph(),
              publish_at: NaiveDateTime.add(NaiveDateTime.utc_now(), 1, :minute),
              organization_id: organization.id
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found news, aborting seeding news.")
    end
  end
end

Atomic.Repo.Seeds.News.run()
