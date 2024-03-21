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
    {:error, [message: "Invalid string format"]}

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

  @doc """
    Returns the current academic year

    ## Examples

        iex> current_year()
        "2022/2023"
  """
  @spec current_year() :: String.t()
  def current_year do
    now = Date.utc_today()
    start_year = calculate_academic_start_year(now)

    "#{start_year}/#{start_year + 1}"
  end

  @doc """
    Returns the start year of the academic year of a given date

    ## Examples

        iex> calculate_academic_start_year(~D[2020-01-01])
        2019

        iex> calculate_academic_start_year(~D[2020-09-01])
        2020

        iex> calculate_academic_start_year(~D[2022-05-31])
        2021

        iex> calculate_academic_start_year(~D[2022-08-31])
        2021

        iex> calculate_academic_start_year(~D[2023-12-05])
        2023
  """
  @spec calculate_academic_start_year(Date.t()) :: integer()
  def calculate_academic_start_year(date) do
    current_year = date.year
    next_year = current_year + 1

    academic_year_start = Timex.parse!("01-09-#{current_year}", "{0D}-{0M}-{YYYY}")
    academic_year_end = Timex.parse!("31-08-#{next_year}", "{0D}-{0M}-{YYYY}")

    if Timex.between?(date, academic_year_start, academic_year_end, inclusive: true) do
      current_year
    else
      current_year - 1
    end
  end

  @doc """
    Returns the next academic year

    ## Examples

        iex> next_year("2020/2021")
        "2021/2022"

        iex> next_year("2021/2022")
        "2022/2023"
  """
  @spec next_year(String.t()) :: String.t()
  def next_year(year) do
    year
    |> String.split("/")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.map(fn x -> x + 1 end)
    |> Enum.map_join("/", fn x -> Integer.to_string(x) end)
  end

  @doc """
    Returns the previous academic year

    ## Examples

        iex> previous_year("2020/2021")
        "2019/2020"

        iex> previous_year("2021/2022")
        "2020/2021"
  """
  @spec previous_year(String.t()) :: String.t()
  def previous_year(year) do
    year
    |> String.split("/")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> Enum.map(fn x -> x - 1 end)
    |> Enum.map_join("/", fn x -> Integer.to_string(x) end)
  end

  defp parse_result({:ok, _year} = result), do: result
  defp parse_result({:error, _errors}), do: :error
end
