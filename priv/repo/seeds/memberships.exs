defmodule Atomic.Repo.Seeds.Memberships do
  @moduledoc """
  Seeds the database with memberships.
  """
  alias Atomic.Accounts.User
  alias Atomic.Ecto.Year
  alias Atomic.Organization
  alias Atomic.Organizations.{Board, BoardDepartments, Membership, Organization, UserOrganization}
  alias Atomic.Repo

  @roles ~w(follower member admin owner)a

  @board_department_names [
    "Presidência",
    "CAOS",
    "Marketing e Conteúdo",
    "Relações Externas e Parcerias",
    "Pegadógico",
    "Recreativo",
    "Vogais",
    "Mesa da Assembleia Geral",
    "Conselho Fiscal"
  ]

  @roles_inside_organization [
    "Presidente",
    "Vice-Presidente",
    "Secretário",
    "Tesoureiro",
    "Vogal",
    "Diretor",
    "Codiretor"
  ]

  def run do
    seed_memberships()
    seed_boards()
    seed_board_departments()
    seed_user_organizations()
  end

  def seed_memberships do
    case Repo.all(Membership) do
      [] ->
        users = Repo.all(User)
        organizations = Repo.all(Organization)

        for user <- users do
          random_number = :rand.uniform(100)

          # 50% chance of having a membership
          if random_number < 50 do
            %Membership{}
            |> Membership.changeset(%{
              "user_id" => user.id,
              "organization_id" => Enum.random(organizations).id,
              "created_by_id" => Enum.random(users).id,
              "role" => Enum.random(@roles)
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found memberships, aborting seeding memberships.")
    end
  end

  def seed_boards do
    case Repo.all(Board) do
      [] ->
        organizations = Repo.all(Organization)

        for organization <- organizations do
          %Board{}
          |> Board.changeset(%{
            "organization_id" => organization.id,
            "name" => Year.current_year()
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found boards, aborting seeding boards.")
    end
  end

  def seed_board_departments do
    case Repo.all(BoardDepartments) do
      [] ->
        boards = Repo.all(Board)

        for board <- boards do
          for i <- 0..(length(@board_department_names) - 1) do
            %BoardDepartments{}
            |> BoardDepartments.changeset(%{
              "board_id" => board.id,
              "name" => Enum.at(@board_department_names, i),
              "priority" => i
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found board departments, aborting seeding board departments.")
    end
  end

  def seed_user_organizations do
    case Repo.all(UserOrganization) do
      [] ->
        users = Repo.all(User)
        board_departments = Repo.all(BoardDepartments)

        for board_department <- board_departments do
          for i <- 0..(length(@roles_inside_organization) - 1) do
            %UserOrganization{}
            |> UserOrganization.changeset(%{
              "user_id" => Enum.random(users).id,
              "board_departments_id" => board_department.id,
              "role" => Enum.at(@roles_inside_organization, i),
              "priority" => i
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found user organizations, aborting seeding user organizations.")
    end
  end
end

Atomic.Repo.Seeds.Memberships.run()
