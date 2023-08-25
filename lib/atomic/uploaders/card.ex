defmodule Atomic.Uploaders.Card do
  @moduledoc """
  Uploader for organization membership cards.
  """
  use Atomic.Uploader
  alias Atomic.Organizations.Organization

  def storage_dir(_version, {_file, %Organization{} = scope}) do
    "uploads/atomic/cards/#{scope.id}"
  end
end
