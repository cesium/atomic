
defmodule StoreWeb.Helpers do
  @moduledoc """
  A module with helper functions to display data in views
  """

  defp two_characters(number) do
    if number < 10 do
      "0#{number}"
    else
      number
    end
  end

  def display_name(person) do
    "#{person.first_name} #{person.last_name}"
  end

  def display_time(datetime) do
    hour = two_characters(datetime.hour)
    minute = two_characters(datetime.minute)

    "#{hour}:#{minute}"
  end

  def display_date(datetime) do
    day = two_characters(datetime.day)
    month = two_characters(datetime.month)
    year = datetime.year

    "#{day}/#{month}/#{year}"
  end
end
