defmodule Atomic.Uploaders.ProfilePicture do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Atomic.Accounts.User

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .png)

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

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x150^ -gravity center -extent 100x150 -format png", :png}
  end

  def transform(:medium, _) do
    {:convert, "-strip -thumbnail 400x600^ -gravity center -extent 400x600 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, %User{} = scope}) do
    "uploads/atomic/profile_pictures/#{scope.id}"
  end
end
