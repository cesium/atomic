defmodule Atomic.Uploader do
  @moduledoc """
  A utility module providing common functions to all uploaders modules.
  Put `use Atomic.Uploader` on top of your uploader module to use it.
  """

  defmacro __using__(opts) do
    quote do
      use Waffle.Definition
      use Waffle.Ecto.Definition

      def validate(file, _) do
        file_extension = file.file_name |> Path.extname() |> String.downcase()

        case Enum.member?(extension_whitelist(), file_extension) do
          true ->
            if file.size <= max_size() do
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
        Keyword.get(unquote(opts), :max_size, 500)
      end
    end
  end
end
