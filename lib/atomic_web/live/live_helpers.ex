defmodule AtomicWeb.LiveHelpers do
  @moduledoc false
  use Gettext, backend: AtomicWeb.Gettext

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
      gettext(
        "An intranet home page featuring a dynamic feed, integrated schedule, and user options for seamless navigation and workflow management"
      ),
    home:
      gettext(
        "An intranet home page featuring a dynamic feed, integrated schedule, and user options for seamless navigation and workflow management"
      ),
    edit_activity:
      gettext(
        "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration"
      ),
    new_activity:
      gettext(
        "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration"
      ),
    activity:
      gettext(
        "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration"
      ),
    activities:
      gettext(
        "Explore and participate in activities, events, and initiatives designed to enhance student engagement and collaboration"
      ),
    edit_announcement:
      gettext(
        "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums."
      ),
    new_announcement:
      gettext(
        "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums."
      ),
    announcement:
      gettext(
        "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums."
      ),
    announcements:
      gettext(
        "Latest updates, important notices, and key announcements for students, ensuring seamless communication between student nucleums."
      ),
    calendar:
      gettext(
        "Stay organized with the calendar—track events, schedules, and important dates in one place"
      ),
    new_department:
      gettext(
        "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community"
      ),
    edit_department:
      gettext(
        "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community"
      ),
    departments:
      gettext(
        "Access information about departments, their roles, and resources, fostering collaboration and communication within the student community"
      ),
    cookies:
      gettext(
        "Learn how we use cookies to enhance your experience, improve functionality, and ensure a secure browsing environment."
      ),
    terms:
      gettext(
        "Explore our terms of service, outlining the rules and guidelines for using our platform, ensuring a safe and respectful environment for all users."
      ),
    privacy:
      gettext(
        "Read our Privacy Policy to understand how we collect, use, and protect your personal information while ensuring data security and transparency"
      ),
    organization:
      gettext(
        "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums"
      ),
    organizations:
      gettext(
        "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums"
      ),
    new_organization:
      gettext(
        "Explore and connect with student organizations and stay informed about events and initiatives within the student nucleums"
      ),
    partner:
      gettext(
        "Learn more about our partner, their mission, and how their collaboration supports and enhances our student community."
      ),
    new_partner:
      gettext(
        "Discover our partners, collaborations, and strategic alliances that support and enhance our student community"
      ),
    edit_partner:
      gettext(
        "Discover our partners, collaborations, and strategic alliances that support and enhance our student community"
      ),
    partners:
      gettext(
        "Discover our partners, collaborations, and strategic alliances that support and enhance our student community"
      ),
    edit_account:
      gettext("Manage your profile, update personal information, and customize settings"),
    user_profile:
      gettext("Manage your profile, update personal information, and customize settings")
  }

  def assign_page_metadata(socket, description_key \\ nil) do
    description =
      Map.get(@default_page_descriptions, description_key, @default_page_descriptions.default)

    socket
    |> assign(:page_description, description)
  end
end
