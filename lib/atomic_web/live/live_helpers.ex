defmodule AtomicWeb.LiveHelpers do
  @moduledoc false

  alias Phoenix.LiveView.JS

  import Phoenix.Component

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      transition:
        {"transition-all transform ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all transform ease-in duration-200",
         "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end

  ## SEO

  @default_page_titles %{
    default: "Atomic",
    home: "Home",
    edit_activity: "Edit Activity",
    new_activity: "New Activity",
    activities: "Activities",
    edit_announcement: "Edit Announcement",
    new_announcement: "New Announcement",
    announcements: "Announcements",
    calendar: "Calendar",
    new_department: "New Department",
    cookies: "Cookies",
    terms: "Terms of Service",
    privacy: "Privacy Policy",
    organizations: "Organizations",
    new_organization: "New Organization",
    new_partner: "New Partner",
    edit_partner: "Edit Partner",
    edit_account: "Edit Account"
  }

  @default_page_descriptions %{
    default: "Atomic",
    home:
      "An intranet home page featuring a dynamic feed, integrated schedule, and user options for seamless navigation and workflow management",
    edit_activity:
      "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration",
    new_activity:
      "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration",
    activity:
      "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration",
    activities:
      "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration",
    edit_announcement:
      "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums.",
    new_announcement:
      "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums.",
    announcements:
      "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums.",
    calendar:
      "Stay organized with the calendar—track events, schedules, and important dates in one place",
    new_department:
      "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community",
    edit_department:
      "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community",
    departments:
      "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community",
    cookies:
      "Learn how we use cookies to enhance your experience, improve functionality, and ensure a secure browsing environment.",
    terms:
      "Explore our terms of service, outlining the rules and guidelines for using our platform, ensuring a safe and respectful environment for all users.",
    privacy:
      "Read our Privacy Policy to understand how we collect, use, and protect your personal information while ensuring data security and transparency",
    organization:
      "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums",
    organizations:
      "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums",
    new_organization:
      "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums",
    new_partner:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    edit_partner:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    partners:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    edit_account: "Manage your profile, update personal information, and customize settings"
  }

  def assign_page_metadata(socket, key \\ nil, context \\ %{}) do
    title = get_page_title(key, context)
    description = Map.get(@default_page_descriptions, key || :default, "Atomic")

    socket
    |> assign(:page_title, title)
    |> assign(:page_description, description)
  end

  defp get_page_title(:activity, %{activity: activity}), do: activity.title

  defp get_page_title(:announcement, %{announcement: announcement}), do: announcement.title

  defp get_page_title(:departments, %{organization: organization}),
    do: "#{organization.name}'s Departments)}"

  defp get_page_title(:organization, %{organization: organization}), do: organization.name

  defp get_page_title(:department, %{department: department}), do: department.name

  defp get_page_title(:partners, %{organization: organization}),
    do: "#{organization.name}'s Partners)}"

  defp get_page_title(:edit_partner, %{partner: partner}), do: partner.name

  defp get_page_title(:user_profile, %{user: user}), do: user.name

  defp get_page_title(key, _context), do: Map.get(@default_page_titles, key || :default, "Atomic")
end
