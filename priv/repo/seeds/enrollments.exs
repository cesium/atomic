defmodule Atomic.Repo.Seeds.Enrollments do
  @moduledoc """
  Seeds the database with enrollments.
  """
  alias Atomic.Accounts.User
  alias Atomic.Activities
  alias Atomic.Activities.{Activity, Enrollment}
  alias Atomic.Repo

  def run do
    seed_enrollments()
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

Atomic.Repo.Seeds.Enrollments.run()
