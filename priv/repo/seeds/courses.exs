defmodule Atomic.Repo.Seeds.Courses do
  @moduledoc """
  Seeds the database with courses.
  """
  alias Atomic.Accounts
  alias Atomic.Accounts.Course
  alias Atomic.Repo

  @courses File.read!("data/courses.txt") |> String.split("\n")
  @cycles ~w(Bachelors Masters PhD)a

  def run do
    case Repo.all(Course) do
      [] ->
        seed_courses()

      _ ->
        Mix.shell().error("Found courses, aborting seeding courses.")
    end
  end

  def seed_courses do
    @courses
    |> Enum.each(fn course ->
      %{
        name: course,
        cycle: Enum.random(@cycles)
      }
      |> Accounts.create_course()
    end)
  end
end

Atomic.Repo.Seeds.Courses.run()
