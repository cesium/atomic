defmodule Atomic.Repo.Seeds.Accounts do
  @moduledoc """
  Seeds the database with users.
  """
  alias Atomic.Accounts
  alias Atomic.Accounts.{Course, User}
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @admins File.read!("priv/fake/admins.txt") |> String.split("\n")
  @students File.read!("priv/fake/students.txt") |> String.split("\n")

  def run do
    case Repo.all(User) do
      [] ->
        seed_users(@admins, :admin)
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
      handle = character |> String.downcase() |> String.replace(~r/\s/, "_")

      user = %{
        "name" => character,
        "email" => email,
        "handle" => handle,
        "password" => "password1234",
        "role" => role,
        "course_id" => Enum.random(courses).id,
        "default_organization_id" => Enum.random(organizations).id
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
