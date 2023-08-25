defmodule Atomic.Uploaders.Post do
  @moduledoc """
  Uploader for session images.
  """
  use Atomic.Uploader
  alias Atomic.Activities.Session

  def storage_dir(_version, {_file, %Session{} = scope}) do
    "uploads/atomic/sessions/#{scope.id}"
  end
end
