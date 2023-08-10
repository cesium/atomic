defmodule Atomic.Repo.Seeds.News do
  alias Atomic.News.New
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  def run do
    seed_news()
  end

  def seed_news() do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      for i <- 1..10 do
        %New{}
        |> New.changeset(%{
          title: "News title #{organization.name} #{i}",
          description: "News description #{organization.name} #{i}",
          organization_id: organization.id
        })
        |> Repo.insert!()
      end
    end
  end
end

Atomic.Repo.Seeds.News.run()
