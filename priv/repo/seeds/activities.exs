defmodule Atomic.Repo.Seeds.Activities do
  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.{Activity, ActivitySession, Enrollment, Session, SessionDepartment}
  alias Atomic.Organizations.Department
  alias Atomic.Repo

  def run do
    seed_activities()
    seed_enrollments()
    seed_session_departments()
  end

  def seed_activities do
    case Repo.all(Activity) do
      [] ->
        location = %{
          name: "Departamento de Informática da Universidade do Minho",
          url: "https://web.di.uminho.pt"
        }

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            sessions: [
              %{
                # We make these dates relative to current date so we are able to quickly test
                start: DateTime.add(DateTime.utc_now(), -12, :hour),
                # the certificate delivery job
                finish: DateTime.add(DateTime.utc_now(), -8, :hour),
                location: location,
                minimum_entries: 0,
                maximum_entries: 10
              }
            ],
            enrolled: 0
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 2",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 3",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 4",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 5",
            description: "This is a test activity",
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 6",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-02 14:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                start: DateTime.from_naive!(~N[2023-04-02 14:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-02 16:00:00], "Etc/UTC"),
                location: location
              }
            ],
            enrolled: 0
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 7",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-05 11:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: 10,
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-05 11:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-05 13:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 8",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-06 15:00:00], "Etc/UTC"),
            sessions: [
              %{
                minimum_entries: 0,
                maximum_entries: Enum.random(10..50),
                enrolled: 0,
                start: DateTime.from_naive!(~N[2023-04-06 15:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-06 17:00:00], "Etc/UTC"),
                location: location
              }
            ]
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found activities, aborting seeding activities.")
    end
  end

  def seed_activities_departments do
    case Repo.all(SessionDepartment) do
      [] ->
        department = Repo.get_by(Department, name: "Merchandise and Partnerships")
        activities = Repo.all(Activity)

        for activity <- activities do
          %SessionDepartment{}
          |> SessionDepartment.changeset(%{
            activity_id: activity.id,
            department_id: department.id
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found session departments, aborting seeding session departments.")
    end
  end

  def seed_enrollments do
    case Repo.all(Enrollment) do
      [] ->
        users = Repo.all(User)
        sessions = Repo.all(Session)

        for user <- users do
          for _ <- 1..Enum.random(1..2) do
            Activities.create_enrollment(
              Enum.random(sessions).id,
              user
            )
          end
        end

      _ ->
        Mix.shell().error("Found enrollments, aborting seeding enrollments.")
    end
  end

  def seed_session_departments do
    case Repo.all(SessionDepartment) do
      [] ->
        department = Repo.get_by(Department, name: "CAOS")
        sessions = Repo.all(Session)

        for session <- sessions do
          %SessionDepartment{}
          |> SessionDepartment.changeset(%{
            session_id: session.id,
            department_id: department.id
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found session departments, aborting seeding session departments.")
    end
  end
end

Atomic.Repo.Seeds.Activities.run()
