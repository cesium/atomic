defmodule Atomic.Repo.Seeds.Organizations do
  alias Atomic.Repo

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Association
  alias Atomic.Organizations.Organization

  def run do
    seed_organizations()
    seed_associations()
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
            }
          }
        )
        |> Repo.insert!()

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
            description: "🇵🇹 The European Law Students' Association UMinho",
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

  def seed_associations() do
    users = Repo.all(User)
    organizations = Repo.all(Organization)

    for user <- users do
      for organization <- organizations do
        prob = 50
        random_number = :rand.uniform(100)
        if random_number < prob do
          %Association{}
          |> Association.changeset(%{
            "user_id" => user.id,
            "organization_id" => organization.id,
            "accepted" => Enum.random([true, false])
          })
          |> Repo.insert!()
        end
      end
    end
  end
end

Atomic.Repo.Seeds.Organizations.run()
