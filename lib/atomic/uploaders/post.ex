defmodule Atomic.Uploaders.Post do
  @moduledoc """
  Uploader for activity images.
  """
  use Atomic.Uploader
  alias Atomic.Activities.Activity

  def storage_dir(_version, {_file, %Activity{} = scope}) do
    "uploads/atomic/activities/#{scope.id}"
  end
end
