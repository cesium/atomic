defmodule Atomic.Repo.Seeds.Departments do
  @moduledoc """
  Seeds the database with departments.
  """
  alias Atomic.Departments
  alias Atomic.Organizations.{Department, Organization}
  alias Atomic.Repo

  @department_names [
    "CAOS",
    "Marketing e Conteúdo",
    "Relações Externas e Parcerias",
    "Pedagógico",
    "Recreativo",
    "Financeiro",
    "Administrativo",
    "Comunicação",
    "Tecnologia",
    "Design"
  ]

  def run do
    case Repo.all(Department) do
      [] ->
        seed_departments()

      _ ->
        Mix.shell().error("Found departments, aborting seeding departments.")
    end
  end

  def seed_departments do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      for i <- 0..Enum.random(4..(length(@department_names) - 1)) do
        %{
          name: Enum.at(@department_names, i),
          organization_id: organization.id
        }
        |> Departments.create_department()
      end
    end
  end
end

Atomic.Repo.Seeds.Departments.run()
