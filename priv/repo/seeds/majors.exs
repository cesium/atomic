defmodule Atomic.Repo.Seeds.Majors do
  def run do
    case Atomic.Repo.all(Atomic.Accounts.Major) do
      [] ->
        create_majors()

      _ ->
        Mix.shell().error("Found majors, aborting seeding majors.")
    end
  end

  def create_majors() do
    File.read!("data/majors.txt")
    |> String.split("\n")
    |> Enum.filter(fn name -> name != "" end)
    |> Enum.map(fn name -> Atomic.Accounts.create_major(%{name: name}) end)
  end
end

Atomic.Repo.Seeds.Majors.run()
