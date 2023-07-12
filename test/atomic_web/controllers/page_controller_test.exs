defmodule AtomicWeb.PageControllerTest do
  use AtomicWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Listing Activities"
  end
end
