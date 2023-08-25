defmodule Atomic.Uploaders.ProfilePicture do
  @moduledoc """
  Uploader for profile pictures.
  """
  use Atomic.Uploader
  alias Atomic.Accounts.User

  def storage_dir(_version, {_file, %User{} = scope}) do
    "uploads/atomic/profile_pictures/#{scope.id}"
  end
end
