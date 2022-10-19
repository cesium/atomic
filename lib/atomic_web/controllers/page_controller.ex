defmodule AtomicWeb.PageController do
  use AtomicWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
