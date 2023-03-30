defmodule Atomic.Ecto.Year do
  @moduledoc """
  PT Phone number type with validation and formatting for Ecto.
  """
  use Ecto.Type

  import AtomicWeb.Gettext

  @spec type :: :string
  def type, do: :string

  @doc """
  Transforms external data into a runtime format.

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format

  ## Examples

    iex> PtMobile.cast("+351 912 345 678")
    {:ok, "+351912345678"}

    iex> PtMobile.cast("929066855")
    {:ok, "+351929066855"}

    iex> PtMobile.cast("+351 939-066-855")
    {:ok, "+351939066855"}

    iex> PtMobile.cast("+351 979 066 855")
    {:error, [message: "número de telemóvel PT inválido"]}

    iex> Gettext.put_locale("en")
    iex> PtMobile.cast("+351 989 066 855")
    {:error, [message: "invalid PT phone number"]}

  """
  def cast(number), do: format(number)

  @doc """
  Transforms the data into a specific format to be stored

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
  """
  def dump(number), do: format(number) |> parse_result()

  @doc """
  Transforms the data back to a runtime format

  ## Parameters
    - number: valid PT phone number with the "+351" indicative in a string format
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
