defmodule Atomic.RateLimiter do
  @moduledoc """
  Rate limiter module for Atomic.
  """
  use Atomic.Context
  alias Atomic.Organizations.Announcement
  alias Atomic.Activities.Activity
  alias Atomic.Repo
  @activities_limit_per_day Application.compile_env!(:atomic, :activities_limit_per_day)
  @announcements_limit_per_day Application.compile_env!(:atomic, :announcements_limit_per_day)

  @doc """
  Returns if the organization has reached the limit of activities for today.

  ## Examples

      iex> limit_activities("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      :ok

      iex> limit_activities("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      {:error, "You have reached the daily limit of activities for today"}
  """
  def limit_activities(organization_id) do
    current_time = DateTime.utc_now()
    twenty_four_hours_ago = DateTime.add(current_time, -86400)

    activity_count =
      Repo.all(
        from a in Activity,
          where: a.organization_id == ^organization_id,
          where: a.inserted_at >= ^twenty_four_hours_ago
      )
      |> Enum.count()

    if activity_count >= @activities_limit_per_day do
      {:error, "You have reached the daily limit of activities for today"}
    else
      :ok
    end
  end

  @doc """
  Returns if the organization has reached the limit of announcements for today.

  ## Examples

      iex> limit_announcements("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      :ok

      iex> limit_announcements("99d7c9e5-4212-4f59-a097-28aaa33c2621")
      {:error, "You have reached the daily limit of announcements for today"}
  """
  def limit_announcements(organization_id) do
    current_time = DateTime.utc_now()
    twenty_four_hours_ago = DateTime.add(current_time, -86400)

    announcement_count =
      Repo.all(
        from a in Announcement,
          where: a.organization_id == ^organization_id,
          where: a.inserted_at >= ^twenty_four_hours_ago
      )
      |> Enum.count()

    if announcement_count >= @announcements_limit_per_day do
      {:error, "You have reached the daily limit of announcements for today"}
    else
      :ok
    end
  end
end
