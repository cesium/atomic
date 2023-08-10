defmodule Atomic.Uploaders.Post do
  @moduledoc false
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Atomic.Activities.Session

  @versions [:original]
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

  def storage_dir(_version, {_file, %Session{} = scope}) do
    "uploads/atomic/sessions/#{scope.id}"
  end
end
