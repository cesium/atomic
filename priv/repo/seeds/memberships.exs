defmodule Atomic.Repo.Seeds.Memberships do
  @moduledoc """
  Seeds the database with memberships.
  """
  alias Atomic.Accounts.User
  alias Atomic.Organization
  alias Atomic.Organizations.{Membership, Organization}
  alias Atomic.Repo

  @roles Membership.roles()

  def run do
    seed_memberships()
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
              "role" => Enum.random(@roles)
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found memberships, aborting seeding memberships.")
    end
  end
end

Atomic.Repo.Seeds.Memberships.run()
