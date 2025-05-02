defmodule Atomic.Uploaders.Banner do
  @moduledoc """
  Uploader for user and department banners.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png .gif)
  alias Atomic.Accounts.User
  alias Atomic.Organizations.Department

  @versions [:original]

  def storage_dir(_version, {_file, %User{} = user}) do
    "uploads/atomic/users/#{user.id}/banner"
  end

  def storage_dir(_version, {_file, %Department{} = department}) do
    "uploads/atomic/departments/#{department.id}/banner"
  end

  def filename(version, _) do
    version
  end
end
