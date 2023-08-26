defmodule Atomic.Uploader do
  @moduledoc """
  A utility context providing common functions to all uploaders modules.
  """

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.svg .jpg .jpeg .gif .png)

  defmacro __using__(_) do
    quote do
      use Waffle.Definition
      use Waffle.Ecto.Definition

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

      def filename(version, _), do: version
    end
  end

  def versions, do: @versions
  def extensions_whitelist, do: @extension_whitelist
end
