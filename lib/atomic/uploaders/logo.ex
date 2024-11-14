defmodule Atomic.Uploaders.Logo do
  @moduledoc """
  Uploader for organization logos.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png .svg)
  alias Atomic.Organizations.Organization

  @versions [:original]

  def storage_dir(_version, {_file, %Organization{} = organization}) do
    "uploads/atomic/organizations/#{organization.id}/logo"
  end

  def filename(version, _) do
    version
  end
end
