defmodule Atomic.Uploaders.PartnerImage do
  @moduledoc """
  Uploader for partner images.
  """
  use Atomic.Uploader
  alias Atomic.Organizations.Partner

  def storage_dir(_version, {_file, %Partner{} = scope}) do
    "uploads/partners/#{scope.id}"
  end
end
