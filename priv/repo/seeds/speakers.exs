defmodule Atomic.Repo.Seeds.Speakers do
  alias Atomic.Repo
  alias Atomic.Activities.Speaker

  def run do
    seed_speakers()
  end

  def seed_speakers() do
    case Repo.all(Speaker) do
      [] ->
        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 2",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 3",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 4",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 5",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 6",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 7",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 8",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

        Speaker.changeset(
          %Speaker{},
          %{
            name: "Test Speaker 9",
            bio: "This is a test speaker"
          }
        )
        |> Repo.insert!()

      _ ->
        IO.puts("Speakers already seeded")
    end
  end
end

Atomic.Repo.Seeds.Speakers.run()
