defmodule Atomic.Repo.Seeds.Partners do
  alias Atomic.Partnerships.Partner
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  def run do
    seed_partners()
  end

  def seed_partners() do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      for i <- 1..10 do
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
