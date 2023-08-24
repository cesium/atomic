defmodule AtomicWeb.HelpersTest do
  @moduledoc """
  Tests for the AtomicWeb.Helpers module
  """
  use ExUnit.Case, async: true

  import AtomicWeb.Helpers

  doctest AtomicWeb.Helpers, except: [build_current_academic_year: 0]
end
