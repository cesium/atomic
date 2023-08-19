defmodule Atomic.Repo.Seeds.Courses do
  alias Atomic.Accounts
  alias Atomic.Accounts.Course
  alias Atomic.Repo

  def run do
    case Repo.all(Course) do
      [] ->
        create_courses()

      _ ->
        Mix.shell().error("Found courses, aborting seeding courses.")
    end
  end

  def create_courses do
    File.read!("data/courses.txt")
    |> String.split("\n")
    |> Enum.filter(fn name -> name != "" end)
    |> Enum.map(fn name -> Accounts.create_course(%{name: name}) end)
  end
end

Atomic.Repo.Seeds.Courses.run()
