defmodule Atomic.Repo.Seeds.Memberships do
  alias Atomic.Organizations.Organization
  alias Atomic.Organizations.Membership
  alias Atomic.Accounts.User
  alias Atomic.Organizations
  alias Atomic.Organizations.Board
  alias Atomic.Organizations.BoardDepartments
  alias Atomic.Organizations.UserOrganization
  alias Atomic.Repo

  def run do
    seed_memberships()
    seed_board()
    seed_board_departments()
    seed_user_organizations()
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

  def seed_board do
    organizations = Repo.all(Organization)

    for organization <- organizations do
      %Board{}
      |> Board.changeset(%{
        "organization_id" => organization.id,
        "year" => "2023/2024"
      })
      |> Repo.insert!()
    end
  end

  def seed_board_departments do
    departments = ["Conselho Fiscal", "Mesa AG", "CAOS", "DMC", "DMP", "Presidência", "Vogais"]
    boards = Repo.all(Board)

    for board <- boards do
      for i <- 0..6 do
        %BoardDepartments{}
        |> BoardDepartments.changeset(%{
          "board_id" => board.id,
          "name" => Enum.at(departments, i),
          "priority" => i
        })
        |> Repo.insert!()
      end
    end
  end

  def seed_user_organizations do
    titles = ["Presidente", "Vice-Presidente", "Secretário", "Tesoureiro", "Vogal"]
    board_departments = Repo.all(BoardDepartments)
    users = Repo.all(User)

    for board_department <- board_departments do
      for i <- 0..4 do
        %UserOrganization{}
        |> UserOrganization.changeset(%{
          "user_id" => Enum.random(users).id,
          "board_departments_id" => board_department.id,
          "role" => Enum.at(titles, i),
          "priority" => i
        })
        |> Repo.insert!()
      end
    end
  end
end

Atomic.Repo.Seeds.Memberships.run()
