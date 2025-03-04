defmodule Atomic.Repo.Seeds.Organizations do
  @moduledoc """
  Seeds the database with organizations.
  """
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Repo
  alias Atomic.Icon

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
      long_name:
        "CeSIUM - Centro de Estudantes de Engenharia Informática da Universidade do Minho",
      description:
        "O CeSIUM é um grupo de estudantes voluntários, que tem como objetivo representar e promover o curso de Engenharia Informática 💾 na UMinho 🎓",
      location: %{
        name: "Departamento de Informática, Campus de Gualtar, Universidade do Minho",
        url: "https://cesium.di.uminho.pt"
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
      case Repo.get_by(Organization, name: organization["name"]) do
        nil ->
          {:ok, new_org} =
            %{
              name: organization["name"],
              long_name: organization["long_name"],
              description: organization["description"]
            }
            |> Organizations.create_organization()

          logo_path = Atomic.Icon.generate_icon(organization)

          new_org
          |> Organization.logo_changeset(%{
            logo: %Plug.Upload{
              path: logo_path,
              content_type: "image/svg",
              filename: "#{organization["name"]}.svg"
            }
          })
          |> Repo.update!()

          File.rm(logo_path)

        _existing_org ->
          IO.puts("Organization '#{organization["name"]}' already exists. Skipping...")
      end
    end)
  end
end

Atomic.Repo.Seeds.Organizations.run()
