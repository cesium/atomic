defmodule AtomicWeb.ActivityEmails do
  @moduledoc """
  A module to build activity related emails.
  """
  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  def activity_certificate_email(enrollment, to: email) do
    base_email(to: email)
    |> subject("[Atomic] Certificado de Participação em \"#{enrollment.activity.title}\"")
    |> assign(:enrollment, enrollment)
    |> render_body("activity_certificate.html")
  end

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.link"})
    |> to(email)
    |> reply_to("caos@cesium.di.uminho.pt")
  end
end
