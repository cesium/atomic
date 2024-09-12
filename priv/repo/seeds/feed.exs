defmodule Atomic.Repo.Seeds.Feed do
  @moduledoc """
  Seeds the database with feed posts.
  """
  alias Atomic.Activities
  alias Atomic.Feed.Post
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @activity_titles [
    "Geek Night",
    "Hack Night",
    "Hackathon",
    "Workshop",
    "Talk",
    "Meetup",
    "Conference",
    "Seminar",
    "Course",
    "Bootcamp",
    "Study session"
  ]

  def run do
    seed_posts()
  end

  def seed_posts do
    case Repo.all(Post) do
      [] ->
        organizations = Repo.all(Organization)

        for i <- 1..200 do
          type = Enum.random([:activity, :announcement])

          case type do
            :activity -> seed_activity(Enum.random(organizations).id, i)
            :announcement -> seed_announcement(Enum.random(organizations).id)
          end
        end

      _ ->
        Mix.shell().error("Found posts, aborting seeding posts.")
    end
  end

  def seed_activity(organization_id, i) do
    location = %{
      name: Faker.Address.city(),
      url: Faker.Internet.url()
    }

    %{
      title: Enum.random(@activity_titles),
      description: Faker.Lorem.paragraph(),
      start: build_start_date(i),
      finish: build_finish_date(i),
      location: %{name: Faker.Company.name(), address: Faker.Address.street_address()},
      minimum_entries: Enum.random(1..10),
      maximum_entries: Enum.random(11..20),
      organization_id: organization_id,
      enrolled: 0
    }
    |> Activities.create_activity_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  def seed_announcement(organization_id) do
    %{
      title: Faker.Lorem.sentence(),
      description: Faker.Lorem.paragraph(),
      organization_id: organization_id
    }
    |> Organizations.create_announcement_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  defp build_start_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.truncate(:second)
  end

  defp build_finish_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.add(Enum.random(1..4), :hour)
    |> NaiveDateTime.truncate(:second)
  end
end

Atomic.Repo.Seeds.Feed.run()
