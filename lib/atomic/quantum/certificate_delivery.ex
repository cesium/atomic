defmodule Atomic.Quantum.CertificateDelivery do
  @moduledoc """

  Task for sending participation certificates for activities which
  ended less than 24h ago. Activities are said to end when their last
  session finishes. Only  participants who were present are eligible
  to receive certificates. The certificates are emailed to the participants,
  but should be viewable in Atomic itself.

  The task was designed to be run at midnight, but it can be run at any time.
  However, it does not check for previously sent certificates, meaning a change
  in run time in production could cause emails to be sent twice.

  """
  import Ecto.Query, warn: false

  alias Atomic.Mailer
  alias Atomic.Repo
  alias Atomic.Activities.{Enrollment, Session}
  alias AtomicWeb.ActivityEmails

  @doc """

  Sends certificates for the activities which ended less than
  24 hours ago.

  Activities are said to end when their last session finishes. Only
  participants who were present are eligible to receive certificates

  """
  def send_certificates do
    included_enrollments()
    |> Enum.each(fn enrollment ->
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
            "Failed to generate certificate for enrollment #{enrollment.id} because: #{inspect(reason)}"
          )
      end
    end)
  end

  # Generates the PDF file for the given enrollment.

  # It uses `wkhtmltopdf` to build it from an HTML template, which
  # is rendered beforehand.
  defp generate_certificate(%Enrollment{} = enrollment) do
    # Create the string corresponding to the HTML to convert
    # to a PDF
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
        "lanpe"
      ]
    )
  end

  # Builds the query to determine the activities to consider for certificate
  # delivery.

  # An activity is considered if its last session
  # ended less than 24h ago. The last session is the one which finishes
  # later (not necessary the one that starts later).

  # The result of the query is the IDs of the activities, not the structs
  # themselves.
  defp last_sessions_query do
    now = DateTime.utc_now()
    minimum_finish = DateTime.add(now, -24, :hour)

    sq =
      from s in Session,
        where: s.finish >= ^minimum_finish and s.finish <= ^now,
        group_by: [s.activity_id],
        select: %{finish: max(s.finish), activity_id: s.activity_id}

    from s in subquery(sq),
      select: s.activity_id
  end

  # Determines all the enrollments eligible to receive participation
  # certificates.

  # An enrollment is eligible if and only if:

  # - The activity it refers to has ended less than 24h ago (meaning its last
  # session ended less than 24h ago)
  # - The user has participated in the session (meaning the present field
  # of the enrollment will be true)

  defp included_enrollments do
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
