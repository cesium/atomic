defmodule Atomic.GenerateAvatar do
  @moduledoc """
  A module for generating unique, GitHub-style avatars for organizations.
  """

  import Phoenix.HTML

  @grid_size 5
  @cell_size 50

  def generate_avatar(seed, output_type) do
    hash = :crypto.hash(:sha256, seed) |> :binary.bin_to_list()
    color = Enum.take(hash, 3)
    grid = build_grid(hash)
    svg = draw(grid, color)

    handle_output(svg, output_type)
  end

  defp handle_output(svg, output) when is_binary(output), do: File.write(output, svg)

  defp handle_output(svg, :svg), do: svg
  defp handle_output(svg, :blob), do: :erlang.term_to_binary(svg)
  defp handle_output(svg, :html), do: raw(svg)

  defp handle_output(_svg, invalid) do
    raise ArgumentError,
          "Invalid output type: #{inspect(invalid)}. Expected one of :svg, :blob, :html, or a file path string."
  end

  defp build_grid(hash) do
    hash
    |> Enum.chunk_every(@grid_size, @grid_size, :discard)
    |> Enum.map(&mirror/1)
    |> List.flatten()
  end

  defp mirror([a, b, c | _]), do: [a, b, c, b, a]

  defp draw(grid, [r, g, b]) do
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
