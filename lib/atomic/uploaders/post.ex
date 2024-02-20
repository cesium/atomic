defmodule Atomic.Uploaders.Post do
  @moduledoc """
  Uploader for posts.
  """
  use Atomic.Uploader

  alias Atomic.Activities.Activity
  alias Atomic.Organizations.Announcement

  def storage_dir(_version, {_file, %Activity{} = scope}) do
    "uploads/atomic/activities/#{scope.id}"
  end

  def storage_dir(_version, {_file, %Announcement{} = scope}) do
    "uploads/atomic/announcements/#{scope.id}"
  end
end
