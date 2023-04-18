defmodule Atomic.CertificateDelivery do
  import Ecto.Query, warn: false
  alias Atomic.Repo
  alias Atomic.Mailer

  alias Atomic.Activities.{Enrollment, Session}

  alias AtomicWeb.ActivityEmails

  def send_certificates do
    enrollments = included_enrollments()

    for enrollment <- enrollments do
      case generate_certificate(enrollment) do
        {:ok, certificate} ->
          Mailer.deliver(
            ActivityEmails.activity_certificate_email(enrollment, certificate,
              to: enrollment.user.email
            )
          )

        {:error, reason} ->
          # We log the error instead of just letting the function crash because we want the task to try and
          # send the remaining certificates despite the failure. If the first certificate would
          # fail to generate, we still want all the others to be sent
          require Logger

          Logger.error(
            "Failed to generate certificate for enrollment #{enrollment.id} because: #{reason}"
          )
      end
    end
  end

  defp generate_certificate(%Enrollment{} = enrollment) do
    Phoenix.View.render_to_string(AtomicWeb.PDFView, "activity_certificate.html",
      enrollment: enrollment
    )
    |> PdfGenerator.generate(
      delete_temporary: true,
      page_size: "A4",
      filename: "certificate_#{enrollment.id}",
      shell_params: [
        "--margin-top",
        "0",
        "--margin-left",
        "0",
        "--margin-right",
        "0",
        "--margin-bottom",
        "0",
        "-O",
        "landscape"
      ]
    )
  end

  defp last_sessions_query() do
    now = DateTime.utc_now()
    minimum_finish = DateTime.add(now, -24, :hour)

    sq =
      from s in Session,
        group_by: [s.activity_id],
        select: %{finish: max(s.finish), activity_id: s.activity_id}

    from s in subquery(sq),
      where: s.finish >= ^minimum_finish and s.finish <= ^now,
      select: s.activity_id
  end

  defp included_enrollments() do
    enrollments =
      from s in subquery(last_sessions_query()),
        inner_join: e in Enrollment,
        on: e.activity_id == s.activity_id,
        where: e.present,
        select: e

    enrollments
    |> Repo.all()
    |> Repo.preload([:activity, :user])
  end
end
