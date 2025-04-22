defmodule Atomic.GenerateAvatar do
  @moduledoc """
  A module for generating unique, GitHub-style avatars for organizations.
  """

  import Phoenix.HTML

  @grid_size 5
  @cell_size 50

  @doc """
  Generates an avatar for the given organization based on its name.
  """
  def generate_avatar(seed, opts \\ []) do
    hash = :crypto.hash(:sha256, seed) |> :binary.bin_to_list()
    color = Enum.take(hash, 3)
    grid = build_grid(hash)
    svg = draw(grid, color)

    case Keyword.get(opts, :path) do
      nil -> handle_return_option(svg, opts)
      path -> save_svg_to_file(svg, path, opts)
    end
  end

  defp handle_avatar_output(svg, opts) do
    case Keyword.get(opts, :return, :svg) do
      :svg -> svg
      :blob -> :erlang.term_to_binary(svg)
      :html -> raw(svg)
      _ -> raise ArgumentError, "Invalid return option"
    end
  end

  defp save_svg_to_file(svg, path, opts) do
    File.write!(path, svg)

    case Keyword.get(opts, :return) do
      nil -> path
      :svg -> svg
      :blob -> :erlang.term_to_binary(svg)
      :html -> raw(svg)
    end
  end

  defp build_grid(hash) do
    hash
    |> Enum.chunk_every(@grid_size, @grid_size, :discard)
    |> Enum.map(&mirror/1)
    |> List.flatten()
  end

  defp mirror(row) do
    [a, b, c | _] = row
  defp draw(grid, [r, g, b]) do
    [a, b, c, b, a]
  end

  defp draw(grid, color) do
    [r, g, b] = color

    header = """
    <svg width="#{@grid_size * @cell_size}" height="#{@grid_size * @cell_size}" xmlns="http://www.w3.org/2000/svg">
    """

    footer = "</svg>"

    body =
      Enum.map_join(
        grid
        |> Enum.with_index()
        |> Enum.filter(fn {val, _} -> rem(val, 2) == 0 end),
        "\n",
        fn {_val, index} ->
          x = rem(index, @grid_size) * @cell_size
          y = div(index, @grid_size) * @cell_size

          "<rect x='#{x}' y='#{y}' width='#{@cell_size}' height='#{@cell_size}' fill='rgb(#{r},#{g},#{b})' />"
        end
      )

    header <> body <> footer
  end
end
