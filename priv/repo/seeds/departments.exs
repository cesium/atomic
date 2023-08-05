defmodule Atomic.Repo.Seeds.Departments do
  alias Atomic.Repo

  alias Atomic.Organizations.Department
  alias Atomic.Organizations.Organization

  def run do
    seed_departments()
  end

  def seed_departments() do
    case Repo.all(Department) do
      [] ->
        Department.changeset(
          %Department{},
          %{
            name: "Merchandise and Partnerships",
            description: "Department responsible for the merchandise and partnerships of CeSIUM.",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Marketing and Content",
            description: "Department responsible for the marketing and content of CeSIUM.",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Recreative",
            description: "Department responsible for the recreative activities of CeSIUM.",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Pedagogical",
            description: "Department responsible for the pedagogical activities of CeSIUM.",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "CAOS",
            description: "Department responsible for the CAOS activities of CeSIUM.",
            organization_id: Repo.get_by(Organization, name: "CeSIUM") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found departments, aborting seeding departments.")
    end
  end
end

Atomic.Repo.Seeds.Departments.run()
