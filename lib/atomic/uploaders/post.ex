defmodule Atomic.Uploaders.Post do
  @moduledoc """
  Uploader for posts.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png .svg)

  alias Atomic.Activities.Activity
  alias Atomic.Organizations.Announcement

  @versions [:original]

  def storage_dir(_version, {_file, %Activity{} = activity}) do
    "uploads/atomic/activities/#{activity.id}/image"
  end

  def storage_dir(_version, {_file, %Announcement{} = announcement}) do
    "uploads/atomic/announcements/#{announcement.id}/image"
  end

  def filename(version, _) do
    version
  end
end
