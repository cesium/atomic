defmodule Atomic.Repo.Seeds.Memberships do
  alias Atomic.Organizations.Organization
  alias Atomic.Organizations.Membership
  alias Atomic.Accounts.User
  alias Atomic.Organizations
  alias Atomic.Repo

  def run do
    seed_memberships()
    seed_users_organizations()
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

Atomic.Repo.Seeds.Memberships.run()
