defmodule Atomic.Factories.NewFactory do
  @moduledoc """
  A factory to generate account related structs
  """

  alias Atomic.News.New

  defmacro __using__(_opts) do
    quote do
      def new_factory do
        %New{
          title: "News title",
          description: "News description"
        }
      end
    end
  end
end
