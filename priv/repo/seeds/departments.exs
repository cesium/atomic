defmodule Atomic.Repo.Seeds.Departments do
  alias Atomic.Repo

  alias Atomic.Departments.Department
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
            # get organization id
            organization_id: Repo.get_by(Organization, name: "Atomic") |> Map.get(:id)
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Marketing and Content",
            organization_id: Repo.get_by(Organization, name: "Atomic") |> Map.get(:id)

          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Recreative",
            organization_id: Repo.get_by(Organization, name: "Atomic") |> Map.get(:id)

          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Pedagogical",
            organization_id: Repo.get_by(Organization, name: "Atomic") |> Map.get(:id)

          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "CAOS",
            organization_id: Repo.get_by(Organization, name: "Atomic") |> Map.get(:id)

          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found departments, aborting seeding departments.")
    end
  end

end

Atomic.Repo.Seeds.Departments.run()
