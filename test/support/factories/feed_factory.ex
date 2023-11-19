defmodule Atomic.Factories.FeedFactory do
  @moduledoc """
  A factory to generate feed related structs
  """
  alias Atomic.Feed.Post

  defmacro __using__(_opts) do
    quote do
      def post_factory do
        %Post{
          publish_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
