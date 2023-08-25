defmodule Atomic.Uploaders.Logo do
  @moduledoc """
  Uploader for organization logos.
  """
  use Atomic.Uploader
  alias Atomic.Organizations.Organization

  def storage_dir(_version, {_file, %Organization{} = scope}) do
    "uploads/atomic/logos/#{scope.id}"
  end
end
