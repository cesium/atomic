defmodule Atomic.Factories.NewFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.Organizations.News

  defmacro __using__(_opts) do
    quote do
      def new_factory do
        %News{
          title: "News title",
          description: "News description",
          publish_at: NaiveDateTime.utc_now()
        }
      end
    end
  end
end
