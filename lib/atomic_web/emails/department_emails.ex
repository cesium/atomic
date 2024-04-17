defmodule AtomicWeb.DepartmentEmails do
  @moduledoc """
  A module to build department related emails.
  """
  use Phoenix.Swoosh, view: AtomicWeb.EmailView

  alias Atomic.Mailer

  @doc """
  Sends an email to the collaborator when their application to join the department is accepted.

  ## Examples

      iex> send_collaborator_request_email(collaborator, department, department_show_url, to: email)
      {:ok, email}

      iex> send_collaborator_request_email(collaborator, department, department_show_url, to: email)
      {:error, reason}
  """
  def send_collaborator_accepted_email(collaborator, department, department_show_url, to: email) do
    base_email(to: email)
    |> subject("[Atomic] You are now a collaborator of #{department.name}")
    |> assign(:collaborator, collaborator)
    |> assign(:department, department)
    |> assign(:department_url, department_show_url)
    |> render_body("collaborator_accepted.html")
    |> Mailer.deliver()
  end

  defp base_email(to: email) do
    new()
    |> from({"Atomic", "noreply@atomic.cesium.pt"})
    |> to(email)
    |> reply_to("caos@cesium.di.uminho.pt")
  end
end
