defmodule Atomic.Ecto.Year do
  @moduledoc """
  Type for storing school years (2019/2020 e.g.)
  """
  use Ecto.Type

  import AtomicWeb.Gettext

  @spec type :: :string
  def type, do: :string

  @doc """
  Transforms external data into a runtime format.

  ## Parameters
    - year: valid year in a string format (yyyy/yyyy)

  ## Examples

    iex> Year.cast("2019/2020")
    {:ok, "2019/2020"}

    iex> Year.cast("2019-2020")
    {:error,  [message: "Invalid string format"]}

    iex> Year.cast("2019-2021")
    {:error, [message: gettext("Second year is not the first + 1")]}

  """
  def cast(number), do: format(number)

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - year: valid year in a string format (yyyy/yyyy)
  """
  def dump(number), do: format(number) |> parse_result()

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - year: valid year in a string format
  """
  def load(number), do: format(number) |> parse_result()

  defp format(year) do
    captures = Regex.named_captures(~r/(?<first>\d+)\/(?<second>\d+)/, year)

    case captures do
      nil ->
        {:error, [message: gettext("Invalid string format")]}

      %{"first" => fst_str, "second" => snd_str} ->
        {first, _} = Integer.parse(fst_str)
        {second, _} = Integer.parse(snd_str)

        if first + 1 == second do
          {:ok, year}
        else
          {:error, [message: gettext("Second year is not the first + 1")]}
        end
    end
  end

  defp parse_result({:ok, _number} = result), do: result
  defp parse_result({:error, _errors}), do: :error
end
