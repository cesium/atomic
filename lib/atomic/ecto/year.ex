defmodule Atomic.Ecto.Year do
  @moduledoc """
  Type for storing school years (2019/2020 e.g.)
  """
  use Ecto.Type

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
  def cast(year), do: format(year)

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - year: valid year in a string format (yyyy/yyyy)
  """
  def dump(year), do: format(year) |> parse_result()

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - year: valid year in a string format
  """
  def load(year), do: format(year) |> parse_result()

  def format(year) when not is_binary(year), do: {:error, :invalid_input}

  def format(year) do
    case Regex.named_captures(~r/\A(?<first>\d{4})\/(?<second>\d{4})\z/, year) do
      %{"first" => first_str, "second" => second_str} ->
        {first, _} = Integer.parse(first_str)
        {second, _} = Integer.parse(second_str)

        case second - first do
          1 -> {:ok, year}
          _ -> {:error, :year_mismatch}
        end

      nil ->
        {:error, :invalid_format}
    end
  end

  defp parse_result({:ok, _year} = result), do: result
  defp parse_result({:error, _errors}), do: :error
end
