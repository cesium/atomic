defmodule Atomic.CertificateDelivery do
  import Ecto.Query, warn: false
  alias Atomic.Organizations
  alias Atomic.Repo
  alias Atomic.Mailer

  alias Atomic.Activities.{Activity, Enrollment, Session}

  alias AtomicWeb.ActivityEmails

  def send_certificates do
    enrollments = included_enrollments()

    for er <- enrollments do
      Mailer.deliver(ActivityEmails.activity_certificate_email(er, to: er.user.email))
    end
  end

  defp generate_certificate(%Enrollment{} = enrollment) do
    enrollment
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
