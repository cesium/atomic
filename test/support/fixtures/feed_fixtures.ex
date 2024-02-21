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
        type: "activity"
      })
      |> Atomic.Feed.create_post()

    post
  end
end
