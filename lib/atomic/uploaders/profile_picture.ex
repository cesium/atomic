defmodule Atomic.Uploaders.ProfilePicture do
  @moduledoc """
  Uploader for profile pictures.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png .gif)
  alias Atomic.Accounts.User

  @versions [:original]

  def storage_dir(_version, {_file, %User{} = user}) do
    "uploads/atomic/users/#{user.id}/profile_picture"
  end

  def filename(version, _) do
    version
  end
end
