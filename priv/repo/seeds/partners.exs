defmodule Atomic.Repo.Seeds.Partners do
  @moduledoc """
  Seeds the database with partners.
  """
  alias Atomic.Organizations.{Organization, Partner}
  alias Atomic.Repo

  def run do
    case Repo.all(Partner) do
      [] ->
        seed_partners()

      _ ->
        Mix.shell().error("Found partners, aborting seeding partners.")
    end
  end

  def seed_partners do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      for _ <- 0..1 do
        %Partner{}
        |> Partner.changeset(%{
          name: Faker.Company.name(),
          description: Faker.Company.catch_phrase(),
          organization_id: organization.id
        })
        |> Repo.insert!()
      end
    end
  end
end

Atomic.Repo.Seeds.Partners.run()
