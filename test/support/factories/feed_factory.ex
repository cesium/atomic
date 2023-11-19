defmodule Atomic.Factories.FeedFactory do
  @moduledoc """
  A factory to generate feed related structs
  """
  alias Atomic.Feed.Post

  defmacro __using__(_opts) do
    quote do
      def post_factory do
        %Post{
          type: Enum.random([:activity, :announcement])
        }
      end
    end
  end
end
