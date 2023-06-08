defmodule AtomicWeb.EnrollmentController do
  use AtomicWeb, :controller

  alias Atomic.Activities
  alias Atomic.Repo
  alias Atomic.Accounts.User
  alias Atomic.Activities.Activity

  @doc """
    Updates an user's enrollment participation for an activity.
  """
  def update(conn, %{"activity_id" => activity_id, "user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    activity = Repo.get!(Activity, activity_id)
    enrollment = Activities.get_enrollment(activity, user)

    if enrollment do
      Activities.update_enrollment(enrollment, %{present: true})

      conn
      |> put_flash(:info, "Participation confirmed")
      |> redirect(to: "/activities/#{activity.id}")
    else
      conn
      |> put_flash(:error, "Enrollment not found")
      |> redirect(to: "/activities/#{activity.id}")
    end
  end
end
