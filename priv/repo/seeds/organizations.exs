defmodule Atomic.Repo.Seeds.Organizations do
  alias Atomic.Repo

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Card
  alias Atomic.Organizations.Membership
  alias Atomic.Organizations.Organization
  alias Atomic.Organizations

  def run do
    seed_organizations()
    seed_users_organizations()
    seed_memberships()
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

  def seed_memberships() do
    users = Repo.all(User)
    organizations = Repo.all(Organization)

    for user <- users do
      for organization <- organizations do
        prob = 50
        random_number = :rand.uniform(100)

        if random_number < prob do
          %Membership{}
          |> Membership.changeset(%{
            "user_id" => user.id,
            "organization_id" => organization.id,
            "created_by_id" => Enum.random(users).id,
            "role" => Enum.random([:follower, :member, :admin, :owner])
          })
          |> Repo.insert!()
        end
      end
    end
  end

  def seed_users_organizations() do
    years = ["2019/2020", "2020/2021", "2021/2022", "2022/2023", "2023/2024"]
    organizations = Repo.all(Organization)
    users = Repo.all(User)

    titles = [
      "Presidente",
      "Vice-Presidente",
      "Tesoureiro",
      "Secretário",
      "Presidente da MAG",
      "Secretário da MAG",
      "Presidente do CF",
      "Secretário do CF"
    ]

    len_titles = length(titles)

    for year <- years do
      for org <- organizations do
        for {user, title} <- Enum.zip(Enum.take_random(users, len_titles), titles) do
          Organizations.create_user_organization(%{
            "year" => year,
            "organization_id" => org.id,
            "user_id" => user.id,
            "title" => title
          })
        end
      end
    end
  end
end

Atomic.Repo.Seeds.Organizations.run()
