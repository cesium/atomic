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

  @default_page_descriptions %{
    default:
      "An intranet home page featuring a dynamic feed, integrated schedule, and user options for seamless navigation and workflow management",
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
    announcement:
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
    partner:
      "Learn more about our partner, their mission, and how their collaboration supports and enhances our student community.",
    new_partner:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    edit_partner:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    partners:
      "Discover our partners, collaborations, and strategic alliances that support and enhance our student community",
    edit_account: "Manage your profile, update personal information, and customize settings",
    user_profile: "Manage your profile, update personal information, and customize settings"
  }

  def assign_page_metadata(socket, description_key \\ nil) do
    description =
      Map.get(@default_page_descriptions, description_key, @default_page_descriptions.default)

    socket
    |> assign(:page_description, description)
  end
end
