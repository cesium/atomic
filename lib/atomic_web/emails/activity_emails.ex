defmodule AtomicWeb.ActivityEmails do
  @moduledoc """
  A module to build activity related emails.
  """
  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  def activity_certificate_email(enrollment, certificate, to: email) do
    base_email(to: email)
    |> subject("[Atomic] Certificado de Participação em \"#{enrollment.activity.title}\"")
    |> assign(:enrollment, enrollment)
    |> attachment(certificate)
    |> render_body("activity_certificate.html")
  end

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
    |> to(email)
    |> reply_to("support@atomic.cesium.pt")
  end
end
