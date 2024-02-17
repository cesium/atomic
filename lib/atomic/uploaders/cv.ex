defmodule Atomic.Uploaders.CV do
  @moduledoc """
  Uploader for CVs.
  """
  use Atomic.Uploader
  alias Atomic.Accounts.User

  def storage_dir(_version, {_file, %User{} = scope}) do
    "uploads/atomic/user_cvs/#{scope.id}"
  end
end
