defmodule Atomic.Repo.Seeds.Feed do
  @moduledoc """
  Seeds the database with feed posts.
  """
  alias Atomic.Activities
  alias Atomic.Feed.Post
  alias Atomic.Organizations
  alias Atomic.Organizations.Organization
  alias Atomic.Repo

  @activity_titles [
    "Geek Night",
    "Hack Night",
    "Hackathon",
    "Workshop",
    "Talk",
    "Meetup",
    "Conference",
    "Seminar",
    "Course",
    "Bootcamp",
    "Study session"
  ]

  @activity_sentences [
    "Join us for an engaging activity where you'll meet like-minded individuals, learn new skills, and participate in meaningful discussions.",
      "activity is a fantastic opportunity to collaborate, exchange ideas, and immerse yourself in a dynamic learning environment.",
      "Whether you're a beginner or an experienced professional, our activity is designed to be an inclusive space for growth and exploration.",
      "Get ready for an interactive activity filled with insightful talks, hands-on activities, and opportunities to connect with industry experts.",
      "At our activity, you'll have the chance to explore new trends, tackle real-world challenges, and expand your professional network.",
      "We believe that learning should be both fun and impactful, and our activity is crafted to provide just that.",
      "Expect a mix of structured learning, open discussions, and hands-on collaboration in this unique activity experience.",
      "activity is more than just an event—it’s a chance to be part of a passionate community that values curiosity and innovation."
    ]

  @announcement_titles [
      "Important Update from the Student Community",
      "Exciting News for All Students!",
      "An Announcement You Won’t Want to Miss!",
      "Stay Informed: Here’s What’s Happening!",
      "Big Changes Coming Soon!",
      "A Special Message for Our Student Members",
      "Let’s Talk: Important Notice for You",
      "Great Opportunities Await – Read More Inside",
      "Here’s What You Need to Know!",
      "Attention Students: We Have Something to Share"
    ]

  @announcement_sentences [
      "We have an important update regarding upcoming student services, so be sure to stay tuned for more details.",
      "A new initiative is launching soon, and we’re excited to have you all be a part of it!",
      "Exciting changes are happening behind the scenes, and we can’t wait to share them with you soon.",
      "Make sure to check your emails for a special announcement regarding student benefits and resources.",
      "Your feedback matters! We’re introducing new ways for students to have a say in campus decisions.",
      "Looking for a way to get more involved? Stay tuned for some great opportunities coming your way.",
      "We appreciate your support and can’t wait to unveil something special just for you!",
      "The student group is growing, and we’re making big plans to improve your experience.",
      "Have questions or suggestions? We’re always listening—reach out to us anytime!",
      "Something exciting is happening on campus, and you’ll want to be part of it!"
    ]

  def run do
    seed_posts()
  end

  def seed_posts do
    case Repo.all(Post) do
      [] ->
        organizations = Repo.all(Organization)

        for i <- 1..200 do
          type = Enum.random([:activity, :announcement])

          case type do
            :activity -> seed_activity(Enum.random(organizations).id, i)
            :announcement -> seed_announcement(Enum.random(organizations).id)
          end
        end

      _ ->
        Mix.shell().error("Found posts, aborting seeding posts.")
    end
  end

  def seed_activity(organization_id, i) do
    location = %{
      name: Faker.Address.city(),
      url: Faker.Internet.url()
    }

    %{
      title: Enum.random(@activity_titles),
      description: Enum.random(@activity_sentences),
      start: build_start_date(i),
      finish: build_finish_date(i),
      location: location,
      minimum_entries: Enum.random(1..10),
      maximum_entries: Enum.random(11..20),
      organization_id: organization_id,
      enrolled: Enum.random(0..10)
    }
    |> Activities.create_activity_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  def seed_announcement(organization_id) do
    %{
      title: Enum.random(@announcement_titles),
      description: Enum.random(@announcement_sentences),
      organization_id: organization_id
    }
    |> Organizations.create_announcement_with_post()
    |> case do
      {:error, changeset} -> Mix.shell().error("#{inspect(changeset)}")
      _ -> :ok
    end
  end

  defp build_start_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.truncate(:second)
  end

  defp build_finish_date(i) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(i, :day)
    |> NaiveDateTime.add(Enum.random(1..4), :hour)
    |> NaiveDateTime.truncate(:second)
  end

end

Atomic.Repo.Seeds.Feed.run()
