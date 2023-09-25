defmodule AtomicWeb.ActivityEmails do
  @moduledoc """
  A module to build activity related emails.
  """
  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  def activity_certificate_email(enrollment, activity, organizations, certificate, to: email) do
    base_email(to: email)
    |> subject("[Atomic] Certificado de Participação em \"#{activity.title}\"")
    |> assign(:enrollment, enrollment)
    |> assign(:activity, activity)
    |> assign(:organizations, organizations)
    |> attachment(certificate)
    |> render_body("activity_certificate.html")
  end

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
    |> to(email)
    |> reply_to("caos@cesium.di.uminho.pt")
  end
end
