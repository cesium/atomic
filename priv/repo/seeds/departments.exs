defmodule Atomic.Repo.Seeds.Departments do
  alias Atomic.Repo

  alias Atomic.Departments.Department

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
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Marketing and Content",
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Recreative",
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "Pedagogical",
          }
        )
        |> Repo.insert!()

        Department.changeset(
          %Department{},
          %{
            name: "CAOS",
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found departments, aborting seeding departments.")
    end
  end

end

Atomic.Repo.Seeds.Departments.run()
