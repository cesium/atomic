defmodule Atomic.Repo.Seeds.News do
  alias Atomic.Organizations.{News, Organization}
  alias Atomic.Repo

  def run do
    seed_news()
  end

  def seed_news do
    case Repo.all(New) do
      [] ->
        organizations = Repo.all(Organization)

        for organization <- organizations do
          for i <- 1..10 do
            %News{}
            |> News.changeset(%{
              title: "News title #{organization.name} #{i}",
              description: "News description #{organization.name} #{i}",
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
