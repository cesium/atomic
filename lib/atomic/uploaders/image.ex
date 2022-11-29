defmodule Atomic.Uploaders.Image do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Atomic.Partnerships.Partner

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

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

  def storage_dir(_version, {_file, %Partner{} = scope}) do
    "uploads/atomic/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version) do
    "uploads/atomic/partner_image_#{version}.png"
  end
end
