defmodule Atomic.Uploaders.Banner do
  @moduledoc """
  Uploader for department banners.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png)

  alias Atomic.Organizations.Department

  @versions [:original]

  def storage_dir(_version, {_file, %Department{} = department}) do
    "uploads/atomic/departments/#{department.id}/banner"
  end

  def filename(version, _) do
    version
  end
end
