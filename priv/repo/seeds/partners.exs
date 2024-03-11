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

    location = %{
      name: Faker.Address.city(),
      url: Faker.Internet.url()
    }

    socials = %{
      instagram: Faker.Internet.slug(),
      facebook: Faker.Internet.slug(),
      x: Faker.Internet.slug(),
      youtube: Faker.Internet.slug(),
      tiktok: Faker.Internet.slug(),
      website: Faker.Internet.url()
    }

    for {organization, i} <- Enum.with_index(organizations) do
      for _ <- 0..5 do
        %Partner{}
        |> Partner.changeset(%{
          name: Faker.Company.name() <> " " <> Integer.to_string(i),
          description: Enum.join(Faker.Lorem.paragraphs(2), "\n"),
          benefits: Enum.join(Faker.Lorem.paragraphs(5), "\n"),
          organization_id: organization.id,
          location: location,
          socials: socials
        })
        |> Repo.insert!()
      end
    end
  end
end

Atomic.Repo.Seeds.Partners.run()
