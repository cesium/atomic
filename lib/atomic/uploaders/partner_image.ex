defmodule Atomic.Uploaders.PartnerImage do
  @moduledoc """
  PartnerImage is used for partners images.
  """

  use Waffle.Definition
  use Waffle.Ecto.Definition

  alias Atomic.Partnerships.Partner

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .png)

  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))
    |> case do
      true -> :ok
      false -> {:error, "Invalid file type. Only .jpg, .jpeg and .png are allowed."}
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
    "uploads/partners/#{scope.id}"
  end
end
