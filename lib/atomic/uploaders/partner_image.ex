defmodule Atomic.Uploaders.PartnerImage do
  @moduledoc """
  Uploader for partner images.
  """
  use Atomic.Uploader, extensions: ~w(.jpg .jpeg .png)

  alias Atomic.Organizations.Partner

  @versions [:original]

  def storage_dir(_version, {_file, %Partner{} = partner}) do
    "uploads/atomic/partners/#{partner.id}/logo"
  end

  def filename(version, _) do
    version
  end
end
