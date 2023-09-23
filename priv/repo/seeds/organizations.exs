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
    # TODO: Update to CeSIUM actual card
    |> Organization.card_changeset(%{
      card: %{
        name_size: 2,
        name_color: "#ff00ff",
        name_x: -10,
        name_y: -100,
        number_size: 2,
        number_color: "#00ff00",
        number_x: 100,
        number_y: 100
      },
      card_image: %Plug.Upload{
        path: "priv/static/images/card.png",
        content_type: "image/png",
        filename: "card.png"
      }
    })
    |> Organization.logo_changeset(%{
      logo: %Plug.Upload{
        path: "priv/static/images/cesium-ORANGE.svg",
        content_type: "image/svg",
        filename: "cesium-ORANGE.svg"
      }
    })
    |> Repo.update!()


    @organizations
    |> Enum.each(fn organization ->
      %{
        name: organization["name"],
        long_name: organization["long_name"],
        description: organization["description"]
      }
      |> Organizations.create_organization()
    end)
  end
end

Atomic.Repo.Seeds.Organizations.run()
