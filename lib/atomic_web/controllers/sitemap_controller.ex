defmodule AtomicWeb.Controllers.SitemapController do
  use AtomicWeb, :controller

  def index(conn, _params) do
    urls = [
      "https://domain.com/",
      "https://domain.com/activities",
      "https://domain.com/organizations",
      "https://domain.com/announcements",
      "https://domain.com/tos",
      "https://domain.com/privacy",
      "https://domain.com/cookies"
    ]

    xml = """
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      #{Enum.map(urls, fn url -> "<url><loc>#{url}</loc></url>" end) |> Enum.join("\n")}
    </urlset>
    """

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, xml)
  end
end
