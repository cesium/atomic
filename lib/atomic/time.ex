defmodule Atomic.Time do
  @moduledoc false
  def lisbon_now do
    Timex.now() |> Timex.Timezone.convert(Timex.Timezone.get("Europe/Lisbon"))
  end
end
