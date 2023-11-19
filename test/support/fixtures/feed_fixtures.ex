defmodule Atomic.FeedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Atomic.Feed` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        publish_at: ~N[2023-11-10 20:49:00],
        type: "activity"
      })
      |> Atomic.Feed.create_post()

    post
  end
end
