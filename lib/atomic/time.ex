defmodule Atomic.Time do
  @moduledoc """
  Time related utilities.
  """

  @timezone "Europe/Lisbon"

  def lisbon_now do
    Timex.now()
    |> Timex.Timezone.convert(timezone())
  end

  def convert_to_lisbon(datetime) do
    Timex.Timezone.convert(datetime, timezone())
  end

  defp timezone do
    Timex.Timezone.get(@timezone)
  end
end
