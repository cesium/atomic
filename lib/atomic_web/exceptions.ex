defmodule AtomicWeb.MismatchError do
  defexception message: "The provided parameters have no relation in the database.",
               plug_status: 500
end
