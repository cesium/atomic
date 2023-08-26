defmodule Atomic.Repo.Seeds.Organizations do
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  def run do
    seed_organizations()
  end

  def seed_organizations do
    case Repo.all(Organization) do
      [] ->
        Organization.changeset(
          %Organization{},
          %{
            name: "CeSIUM",
            long_name: "Centro de Estudantes de Engenharia Informática da Universidade do Minho",
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
            long_name: "Associação de Estudantes de Direito da Universidade do Minho",
            description:
              "O AEDUM é um grupo de estudantes voluntários, que tem como objetivo representar e promover o curso de Direito na UMinho 🎓",
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
            long_name: "The European Law Students' membership UMinho",
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
            long_name: "🇵🇹 The European Law Students' membership UMinho",
            description: "Núcleo de Estudantes de Medicina da Universidade do Minho.",
            location: %{
              name: "Escola de Medicina, Campus de Gualtar, Universidade do Minho",
              url: ""
            }
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found organizations, aborting seeding organizations.")
    end
  end
end

Atomic.Repo.Seeds.Organizations.run()
