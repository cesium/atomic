defmodule Atomic.Repo.Seeds.Courses do
  def run do
    case Atomic.Repo.all(Atomic.Accounts.Course) do
      [] ->
        create_courses()

      _ ->
        Mix.shell().error("Found courses, aborting seeding courses.")
    end
  end

  def create_courses() do
    File.read!("data/courses.txt")
    |> String.split("\n")
    |> Enum.filter(fn name -> name != "" end)
    |> Enum.map(fn name -> Atomic.Accounts.create_course(%{name: name, cycle: :Bachelors}) end)
  end
end

Atomic.Repo.Seeds.Courses.run()
