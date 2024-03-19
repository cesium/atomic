defmodule Atomic.Uploaders.Banner do
  @moduledoc """
  Uploader for department banners.
  """
  use Atomic.Uploader
  alias Atomic.Organizations.Department

  def storage_dir(_version, {_file, %Department{} = scope}) do
    "uploads/atomic/departments/#{scope.id}/banner"
  end
end
