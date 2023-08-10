defmodule Atomic.Repo.Seeds.Organizations do
  alias Atomic.Repo

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Card
  alias Atomic.Organizations.Membership
  alias Atomic.Organizations.Organization
  alias Atomic.Organizations

  def run do
    seed_organizations()
  end

  def seed_organizations() do
    case Repo.all(Organization) do
      [] ->
        Organization.changeset(
          %Organization{},
          %{
            name: "CeSIUM",
            description:
              "O CeSIUM é um grupo de estudantes voluntários, que tem como objetivo representar e promover o curso de Engenharia Informática 💾 na UMinho 🎓",
            location: %{
              name: "Departamento de Informática, Campus de Gualtar, Universidade do Minho",
              url: "https://cesium.di.uminho.pt"
            },
            card: %{
              name_size: 2,
              name_color: "#ff00ff",
              name_x: -10,
              name_y: -100,
              number_size: 2,
              number_color: "#00ff00",
              number_x: 100,
              number_y: 100
            }
          }
        )
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

        Organization.changeset(
          %Organization{},
          %{
            name: "AEDUM",
            description: "Associação de Estudantes de Direito da Universidade do Minho",
            location: %{
              name: "Escola de Direito, Campus de Gualtar, Universidade do Minho",
              url: ""
            }
          }
        )
        |> Repo.insert!()

        Organization.changeset(
          %Organization{},
          %{
            name: "ELSA",
            description: "🇵🇹 The European Law Students' membership UMinho",
            location: %{
              name: "Escola de Direito, Campus de Gualtar, Universidade do Minho",
              url: ""
            }
          }
        )
        |> Repo.insert!()

        Organization.changeset(
          %Organization{},
          %{
            name: "NEMUM",
            description: "Núcleo de Estudantes de Medicina da Universidade do Minho.",
            location: %{
              name: "Escola de Medicina, Campus de Gualtar, Universidade do Minho",
              url: ""
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
