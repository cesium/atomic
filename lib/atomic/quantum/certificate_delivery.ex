defmodule Atomic.Quantum.CertificateDelivery do
  @moduledoc """

  Task for sending participation certificates for activities which
  ended less than 24h ago. Activities are said to end when their last
  activity finishes. Only  participants who were present are eligible
  to receive certificates. The certificates are emailed to the participants,
  but should be viewable in Atomic itself.

  The task was designed to be run at midnight, but it can be run at any time.
  However, it does not check for previously sent certificates, meaning a change
  in run time in production could cause emails to be sent twice.

  """
  import Ecto.Query, warn: false

  alias Atomic.Mailer
  alias Atomic.Repo
  alias Atomic.Activities.{Activity, Enrollment}
  alias Atomic.Organizations.Organization

  alias AtomicWeb.ActivityEmails

  @doc """

  Sends certificates for the activities which ended less than
  24 hours ago.

  Activities are said to end when their last activity finishes. Only
  participants who were present are eligible to receive certificates

  """
  def send_certificates do
    included_enrollments()
    |> Enum.each(fn enrollment ->

      activity = Repo.get_by!(Activity, id: enrollment.activity_id)
        |> Repo.preload([:departments])

      organizations = activity.departments
      |> Enum.map(fn d -> d.organization_id end)
      |> Enum.dedup()
      |> Enum.map(fn o -> Repo.get_by!(Organization, id: o).name end)

      case generate_certificate(enrollment, activity, organizations) do
        {:ok, certificate} ->
          Mailer.deliver(
            ActivityEmails.activity_certificate_email(enrollment, activity, organizations, certificate,
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
  defp generate_certificate(%Enrollment{} = enrollment, %Activity{} = activity, organizations) do
    # Create the string corresponding to the HTML to convert
    # to a PDF
    Phoenix.View.render_to_string(AtomicWeb.PDFView, "activity_certificate.html",
      enrollment: enrollment,
      activity: activity,
      organizations: organizations
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

  # Builds the query to determine the activities to consider for certificate
  # delivery.

  # An activity is considered if its last activity
  # ended less than 24h ago. The last activity is the one which finishes
  # later (not necessary the one that starts later).

  # The result of the query is the IDs of the activities, not the structs
  # themselves.
  defp last_activities_query do
    now = DateTime.utc_now()
    minimum_finish = DateTime.add(now, -24, :hour)

    from a in Activity,
      where: a.finish >= ^minimum_finish and a.finish <= ^now
  end

  # Determines all the enrollments eligible to receive participation
  # certificates.

  # An enrollment is eligible if and only if:

  # - The activity it refers to has ended less than 24h ago
  # - The user has participated in the activity (meaning the present field
  # of the enrollment will be true)

  defp included_enrollments do
    enrollments =
      from s in subquery(last_activities_query()),
        inner_join: e in Enrollment,
        on: e.activity_id == s.id,
        where: e.present,
        select: e

    enrollments
    |> Repo.all()
    |> Repo.preload([:activity, :user])
  end
end
