defmodule AtomicWeb.Components.Helpers do
  @moduledoc """
  A module with helper functions to display data in live components
  """

  @doc """
  Converts a Flop struct into a keyword list that can be used as a query with
  Phoenix route helper functions.

  Default limits and default order parameters set via the application
  environment are omitted. You can pass the `:for` option to pick up the
  default options from a schema module deriving `Flop.Schema`. You can also
  pass `default_limit` and `default_order` as options directly. The function
  uses `Flop.get_option/2` internally to retrieve the default options.

  ## Examples

      iex> to_query(%Flop{})
      []

      iex> f = %Flop{order_by: [:name, :age], order_directions: [:desc, :asc]}
      ...> to_query(f)
      [order_directions: [:desc, :asc], order_by: [:name, :age]]
      iex> f |> to_query |> Plug.Conn.Query.encode()
      "order_directions[]=desc&order_directions[]=asc&order_by[]=name&order_by[]=age"

      iex> f = %Flop{page: 5, page_size: 20}
      ...> to_query(f)
      [page_size: 20, page: 5]

      iex> f = %Flop{first: 20, after: "g3QAAAABZAAEbmFtZW0AAAAFQXBwbGU="}
      ...> to_query(f)
      [first: 20, after: "g3QAAAABZAAEbmFtZW0AAAAFQXBwbGU="]

      iex> f = %Flop{
      ...>   filters: [
      ...>     %Flop.Filter{field: :name, op: :=~, value: "Mag"},
      ...>     %Flop.Filter{field: :age, op: :>, value: 25}
      ...>   ]
      ...> }
      ...>
      ...> to_query(f)
      [
        filters: %{
          0 => %{field: :name, op: :=~, value: "Mag"},
          1 => %{field: :age, op: :>, value: 25}
        }
      ]
      iex> f |> to_query() |> Plug.Conn.Query.encode()
      "filters[0][field]=name&filters[0][op]=%3D~&filters[0][value]=Mag&filters[1][field]=age&filters[1][op]=%3E&filters[1][value]=25"

      iex> f = %Flop{page: 5, page_size: 20}
      ...> to_query(f, default_limit: 20)
      [page: 5]

  """
  def to_query(%Flop{filters: filters} = flop, opts \\ []) do
    filter_map =
      filters
      |> Stream.with_index()
      |> Enum.into(%{}, fn {filter, index} ->
        {index, Map.from_struct(filter)}
      end)

    default_limit = Flop.get_option(:default_limit, opts)
    default_order = Flop.get_option(:default_order, opts)

    []
    |> maybe_put(:offset, flop.offset, 0)
    |> maybe_put(:page, flop.page, 1)
    |> maybe_put(:after, flop.after)
    |> maybe_put(:before, flop.before)
    |> maybe_put(:page_size, flop.page_size, default_limit)
    |> maybe_put(:limit, flop.limit, default_limit)
    |> maybe_put(:first, flop.first, default_limit)
    |> maybe_put(:last, flop.last, default_limit)
    |> maybe_put_order_params(flop, default_order)
    |> maybe_put(:filters, filter_map)
  end

  defp maybe_put(params, key, value, default \\ nil)
  defp maybe_put(keywords, _, nil, _), do: keywords
  defp maybe_put(keywords, _, [], _), do: keywords
  defp maybe_put(keywords, _, map, _) when map == %{}, do: keywords
  defp maybe_put(keywords, _, val, val), do: keywords
  defp maybe_put(keywords, key, value, _), do: Keyword.put(keywords, key, value)

  defp maybe_put_order_params(
         params,
         %{order_by: order_by, order_directions: order_directions},
         %{order_by: order_by, order_directions: order_directions}
       ),
       do: params

  defp maybe_put_order_params(
         params,
         %{order_by: order_by, order_directions: order_directions},
         _
       ) do
    params
    |> maybe_put(:order_by, order_by)
    |> maybe_put(:order_directions, order_directions)
  end

  def atom_to_string_capitalize(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.capitalize()
  end
end
