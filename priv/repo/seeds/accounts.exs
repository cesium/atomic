defmodule Atomic.Repo.Seeds.Accounts do
  @moduledoc """
  Seeds the database with users.
  """
  alias Atomic.Accounts
  alias Atomic.Accounts.{Course, User}
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @masters File.read!("priv/fake/masters.txt") |> String.split("\n")
  @students File.read!("priv/fake/students.txt") |> String.split("\n")

  def run do
    case Repo.all(User) do
      [] ->
        seed_users(@masters, :master)
        seed_users(@students, :student)

      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  def seed_users(characters, role) do
    courses = Repo.all(Course)
    organizations = Repo.all(Organization)

    for character <- characters do
      email = (character |> String.downcase() |> String.replace(~r/\s*/, "")) <> "@mail.pt"
      slug = character |> String.downcase() |> String.replace(~r/\s/, "_")

      phone_number =
        "+3519#{Enum.random([1, 2, 3, 6])}#{for _ <- 1..7, do: Enum.random(0..9) |> Integer.to_string()}"

      user = %{
        "name" => character,
        "email" => email,
        "slug" => slug,
        "phone_number" => phone_number,
        "password" => "password1234",
        "role" => role,
        "course_id" => Enum.random(courses).id,
        "current_organization_id" => Enum.random(organizations).id
      }

      case Accounts.register_user(user) do
        {:ok, changeset} ->
          Repo.update!(Accounts.User.confirm_changeset(changeset))

        {:error, changeset} ->
          Mix.shell().error(Kernel.inspect(changeset.errors))
      end
    end
  end
end

Atomic.Repo.Seeds.Accounts.run()
