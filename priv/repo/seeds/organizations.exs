defmodule Atomic.Repo.Seeds.Organizations do
  @moduledoc """
  Seeds the database with organizations.
  """
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @organizations File.read!("priv/fake/organizations.json") |> Jason.decode!()

  def run do
    case Repo.all(Organization) do
      [] ->
        seed_organizations()

      _ ->
        Mix.shell().error("Found organizations, aborting seeding organizations.")
    end
  end

  def seed_organizations do
    # Seed CeSIUM
    %Organization{
      name: "CeSIUM",
      long_name: "Centro de Estudantes de Engenharia Informática da Universidade do Minho",
      description:
        "O CeSIUM é um grupo de estudantes voluntários, que tem como objetivo representar e promover o curso de Engenharia Informática 💾 na UMinho 🎓",
      location: "Edifício 7, Universidade do Minho",
      socials: %{
        facebook: "cesiuminho",
        instagram: "cesiuminho",
        x: "cesiuminho",
        linkedin: "cesiuminho",
        website: "https://cesium.pt"
      }
    }
    |> Repo.insert!()
    |> Organization.logo_changeset(%{
      logo: %Plug.Upload{
        path: "priv/static/images/cesium-ORANGE.svg",
        content_type: "image/svg",
        filename: "cesium-ORANGE.svg"
      }
    })
    |> Repo.update!()

    # Seed other organizations
    @organizations
    |> Enum.each(fn organization ->
      %{
        name: organization["name"],
        long_name: organization["long_name"],
        description: organization["description"],
        website: Faker.Internet.url()
      }
      |> Organizations.create_organization()
    end)
  end
end

Atomic.Repo.Seeds.Organizations.run()
