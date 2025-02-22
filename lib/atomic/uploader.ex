defmodule Atomic.Uploader do
  @moduledoc """
  A utility module providing common functions to all uploaders modules.
  Put `use Atomic.Uploader` on top of your uploader module to use it.
  """

  defmacro __using__(opts) do
    quote do
      use Waffle.Definition
      use Waffle.Ecto.Definition

      def validate({file, _}) do
        file_extension = file.file_name |> Path.extname() |> String.downcase()
        size = file_size(file)

        case Enum.member?(extension_whitelist(), file_extension) do
          true ->
            if size <= max_size() do
              :ok
            else
              {:error, "file size exceeds maximum allowed size"}
            end

          false ->
            {:error, "invalid file extension"}
        end
      end

      def extension_whitelist do
        Keyword.get(unquote(opts), :extensions, [])
      end

      def max_size do
        Keyword.get(unquote(opts), :max_file_size, 100_000_000)
      end

      def file_size(%Waffle.File{} = file) do
        File.stat!(file.path) |> Map.get(:size)
      end
    end
  end
end
