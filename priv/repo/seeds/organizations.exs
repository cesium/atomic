defmodule Atomic.Repo.Seeds.Organizations do
  alias Atomic.Repo

  alias Atomic.Organizations.Organization

  def run do
    seed_organizations()
  end

  def seed_organizations() do
    case Repo.all(Organization) do
      [] ->
        Organization.changeset(
          %Organization{},
          %{
            name: "CES",
            description: "Centro de Estudos e Sistemas Interativos Multimédia",
            location: %{
              name: "CES",
              url: "https://cesium.di.uminho.pt",
            }
          }
        )
        |> Repo.insert!()

        Organization.changeset(
          %Organization{},
          %{
            name: "Atomic",
            description: "Atomic is a company that provides a platform for the development of digital products and services.",
            location: %{
              name: "Atomic",
              url: "https://atomic.pt",
            }
          }
        )
        |> Repo.insert!()

      _ ->
        :ok
    end
  end
end

Atomic.Repo.Seeds.Organizations.run()
