defmodule AtomicWeb.Controllers.SitemapController do
  use AtomicWeb, :controller

  @host System.get_env("PHX_HOST") || "atomic.cesium.pt"

  def index(conn, _params) do
    paths = [
      "/",
      "/activities",
      "/organizations",
      "/announcements",
      "/tos",
      "/privacy",
      "/cookies"
    ]

    urls = Enum.map(paths, &build_path/1)

    xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      #{Enum.map_join(urls, "\n", fn url -> "<url><loc>#{url}</loc></url>" end)}
    </urlset>
    """

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, xml)
  end

  defp build_path(path), do: "https://#{@host}#{path}"
end
