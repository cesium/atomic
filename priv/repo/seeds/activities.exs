defmodule Atomic.Repo.Seeds.Activities do
  @moduledoc """
  Seeds the database with activities.
  """
  alias Atomic.Departments
  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.{Activity, ActivityDepartment, Enrollment}
  alias Atomic.Organizations.Department
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
    seed_activities()
    seed_enrollments()
    seed_activity_departments()
  end

  def seed_activities do
    case Repo.all(Activity) do
      [] ->
        organizations = Repo.all(Organization)

        for i <- 1..30 do
          location = %{
            name: Faker.Address.city(),
            url: Faker.Internet.url()
          }

          %{
            title: Enum.random(@activity_titles),
            description: Faker.Lorem.paragraph(),
            start: build_start_date(i),
            finish: build_finish_date(i),
            location: location,
            minimum_entries: Enum.random(1..10),
            maximum_entries: Enum.random(11..20),
            organization_id: Enum.random(organizations).id
          }
          |> Activities.create_activity()
        end

      _ ->
        Mix.shell().error("Found activities, aborting seeding activities.")
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
    |> NaiveDateTime.add(2, :hour)
    |> NaiveDateTime.truncate(:second)
  end

  def seed_activity_departments do
    case Repo.all(ActivityDepartment) do
      [] ->
        activities = Repo.all(Activity)

        for activity <- activities do
          %ActivityDepartment{}
          |> ActivityDepartment.changeset(%{
            activity_id: activity.id,
            department_id:
              Enum.random(
                Departments.list_departments_by_organization_id(activity.organization_id)
              ).id
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found activity departments, aborting seeding activity departments.")
    end
  end

  def seed_enrollments do
    case Repo.all(Enrollment) do
      [] ->
        users = Repo.all(User)
        activities = Repo.all(Activity)

        for user <- users do
          for _ <- 1..Enum.random(1..2) do
            Activities.create_enrollment(
              Enum.random(activities).id,
              user
            )
          end
        end

      _ ->
        Mix.shell().error("Found enrollments, aborting seeding enrollments.")
    end
  end
end

Atomic.Repo.Seeds.Activities.run()
