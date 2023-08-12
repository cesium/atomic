defmodule Atomic.Repo.Seeds.Activities do
  alias Atomic.Activities.SessionDepartment
  alias Atomic.Repo

  alias Atomic.Accounts.User
  alias Atomic.Organizations.Department
  alias Atomic.Activities.SessionDepartment
  alias Atomic.Activities.Session
  alias Atomic.Organizations.Organization
  alias Atomic.Activities.{Activity, Enrollment, Location}

  def run do
    seed_activities()
    seed_enrollments()
    seed_session_departments()
  end

  def seed_activities() do
    location = %{
      name: "Departamento de Informática da Universidade do Minho",
      url: "https://web.di.uminho.pt"
    }

    case Repo.all(Activity) do
      [] ->
        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity",
            description: "This is a test activity",
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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
            activity_sessions: [
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

  def seed_activities_departments() do
    department = Repo.get_by(Department, name: "Merchandise and Partnerships")

    case Repo.all(SessionDepartment) do
      [] ->
        for activity <- Repo.all(Activity) do
          %SessionDepartment{}
          |> SessionDepartment.changeset(%{
            activity_id: activity.id,
            department_id: department.id
          })
          |> Repo.insert!()
        end
    end
  end

  def seed_enrollments() do
    sessions = Repo.all(Session)

    case Repo.all(Enrollment) do
      [] ->
        for user <- Repo.all(User) do
          for _ <- 1..Enum.random(1..3) do
            %Enrollment{}
            |> Enrollment.changeset(%{
              user_id: user.id,
              session_id: Enum.random(sessions).id,
              present: Enum.random([true, false])
            })
            |> Repo.insert!()
          end
        end
    end
  end

  def seed_session_departments() do
    case Repo.all(SessionDepartment) do
      [] ->
        department = Repo.get_by(Department, name: "CAOS")

        for session <- Repo.all(Session) do
          %SessionDepartment{}
          |> SessionDepartment.changeset(%{
            session_id: session.id,
            department_id: department.id
          })
          |> Repo.insert!()
        end
    end
  end
end

Atomic.Repo.Seeds.Activities.run()
