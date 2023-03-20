defmodule Atomic.Repo.Seeds.Activities do
  alias Atomic.Repo

  alias Atomic.Departments.Department
  alias Atomic.Organizations.Organization
  alias Atomic.Activities.Activity

  def run do
    seed_activities()
  end

  def seed_activities() do
    case Repo.all(Activity) do
      [] ->
        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC")
              }
            ],
            enrolled: 0,
            departments: [
              Repo.get_by(Department, name: "Merchandise and Partnerships") |> Map.get(:id)
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 2",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "Marketing and Content") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 3",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "Recreative") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 4",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            date: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "Pedagogical") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 5",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-01 10:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-01 12:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "CAOS") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 6",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            date: DateTime.from_naive!(~N[2023-04-02 14:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-02 14:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-02 16:00:00], "Etc/UTC")
              }
            ],
            enrolled: 0,
            departments: [
              Repo.get_by(Department, name: "Merchandise and Partnerships") |> Map.get(:id)
            ]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 7",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            date: DateTime.from_naive!(~N[2023-04-05 11:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-05 11:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-05 13:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "Marketing and Content") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

        Activity.changeset(
          %Activity{},
          %{
            title: "Test Activity 8",
            description: "This is a test activity",
            minimum_entries: 0,
            maximum_entries: 10,
            enrolled: 0,
            date: DateTime.from_naive!(~N[2023-04-06 15:00:00], "Etc/UTC"),
            activity_sessions: [
              %{
                start: DateTime.from_naive!(~N[2023-04-06 15:00:00], "Etc/UTC"),
                finish: DateTime.from_naive!(~N[2023-04-06 17:00:00], "Etc/UTC")
              }
            ],
            enrollments: [
              %{
                user_id: 1
              }
            ],
            departments: [Repo.get_by(Department, name: "Recreative") |> Map.get(:id)]
          }
        )
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found activities, aborting seeding activities.")
    end
  end
end

Atomic.Repo.Seeds.Activities.run()
