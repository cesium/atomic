defmodule Atomic.Uploaders.Banner do
  @moduledoc """
  Uploader for department banners.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png)
  alias Atomic.Accounts.User

  @versions [:original]

  def storage_dir(_version, {_file, %User{} = user}) do
    "uploads/atomic/users/#{user.id}/banner"
  end

  def filename(version, _) do
    version
  end
end
