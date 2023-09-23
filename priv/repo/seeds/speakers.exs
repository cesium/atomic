defmodule Atomic.Repo.Seeds.Speakers do
  @moduledoc """
  Seeds the database with speakers.
  """
  alias Atomic.Activities
  alias Atomic.Activities.Speaker
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @organizations Repo.all(Organization)

  def run do
    case Repo.all(Speaker) do
      [] ->
        seed_speakers()

      _ ->
        Mix.shell().error("Found speakers, aborting seeding speakers.")
    end
  end

  def seed_speakers do
    for _ <- 0..30 do
      organization = Enum.random(@organizations)

      attrs = %{
        "name" => Faker.Person.name(),
        "bio" => Faker.Lorem.sentence(),
        "organization_id" => organization.id
      }

      Activities.create_speaker(attrs)
    end
  end
end

Atomic.Repo.Seeds.Speakers.run()
