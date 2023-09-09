defmodule Atomic.Factories.AnnouncementFactory do
  @moduledoc """
  A factory to generate organizations announcements
  """

  alias Atomic.Organizations.Announcement

  defmacro __using__(_opts) do
    quote do
      def announcement_factory do
        %Announcement{
          organization: build(:organization),
          title: "Announcement title",
          description: "Announcement description",
          publish_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
