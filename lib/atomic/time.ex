defmodule Atomic.Time do
  @moduledoc false
  @doc """
    Returns the current time in Lisbon.
  """
  def lisbon_now do
    Timex.now() |> Timex.Timezone.convert(Timex.Timezone.get("Europe/Lisbon"))
  end
end
