defmodule Atomic.Factories.NewsFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Organizations.News

  defmacro __using__(_opts) do
    quote do
      def news_factory do
        %News{
          organization: build(:organization),
          title: "News title",
          description: "News description",
          publish_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
