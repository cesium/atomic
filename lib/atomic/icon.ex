defmodule Atomic.Icon do
  @moduledoc """
  A module for generating unique, GitHub-style avatars for organizations.

  This module takes an organization's name as input, hashes it, and then generates
  a 5x5 grid-based icon using a mirroring pattern. The resulting icon is saved as
  an SVG file in the `priv/static/images` directory.
  """

  @grid_size 5
  @cell_size 50

  @doc """
  Generates an icon for the given organization based on its name.

  ## Returns
    - The file path of the generated SVG icon.
  """
  def generate_icon(organization) do
    input = organization["name"]
    hash = :crypto.hash(:sha256, input) |> :binary.bin_to_list()
    color = Enum.take(hash, 3)
    grid = build_grid(hash)

    svg = draw(grid, color)
    path = "priv/static/images/#{input}.svg"
    File.write!(path, svg)
    path
  end

  @doc """
  Builds a 5x5 mirrored grid based on the hash values.
  """
  defp build_grid(hash) do
    hash
    |> Enum.chunk_every(@grid_size, @grid_size, :discard)
    |> Enum.map(&mirror/1)
    |> List.flatten()
  end

  @doc """
  Mirrors a row to ensure symmetry.
  """
  defp mirror(row) do
    [a, b, c | _] = row
    [a, b, c, b, a]
  end

  @doc """
  Draws the SVG representation of the grid.
  """
  defp draw(grid, color) do
    [r, g, b] = color

    header = """
    <svg width="#{@grid_size * @cell_size}" height="#{@grid_size * @cell_size}" xmlns="http://www.w3.org/2000/svg">
    """

    footer = "</svg>"

    body =
      grid
      |> Enum.with_index()
      |> Enum.filter(fn {val, _} -> rem(val, 2) == 0 end)
      |> Enum.map(fn {_val, index} ->
        x = rem(index, @grid_size) * @cell_size
        y = div(index, @grid_size) * @cell_size

        "<rect x='#{x}' y='#{y}' width='#{@cell_size}' height='#{@cell_size}' fill='rgb(#{r},#{g},#{b})' />"
      end)
      |> Enum.join("\n")

    header <> body <> footer
  end
end
