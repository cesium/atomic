defmodule AtomicWeb.Controllers.SitemapController do
  use AtomicWeb, :controller

  def index(conn, _params) do
    urls = [
      "https://atomic.cesium.pt/",
      "https://atomic.cesium.pt/activities",
      "https://atomic.cesium.pt/organizations",
      "https://atomic.cesium.pt/announcements",
      "https://atomic.cesium.pt/tos",
      "https://atomic.cesium.pt/privacy",
      "https://atomic.cesium.pt/cookies"
    ]

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
end
