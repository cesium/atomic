defmodule Atomic.Uploaders.Card do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Atomic.Organizations.Organization

  @versions [:original, :rotated]
  @extension_whitelist ~w(.svg .jpg .jpeg .gif .png)

  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))
    |> case do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, %Organization{} = scope}) do
    "uploads/atomic/cards/#{scope.id}"
  end
end
