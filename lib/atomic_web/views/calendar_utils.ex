defmodule AtomicWeb.CalendarUtils do
  @moduledoc """
  Calendar utils functions to be used on all views.
  """
  use Phoenix.HTML
  use Timex

  def build_beggining_date(_timezone, "month", current_date) do
    Timex.beginning_of_month(current_date) |> Timex.to_naive_datetime()
  end

  def build_beggining_date(_timezone, "week", current_date) do
    Timex.beginning_of_week(current_date) |> Timex.to_naive_datetime()
  end

  def build_ending_date(_timezone, "month", current_date) do
    Timex.end_of_month(current_date) |> Timex.to_naive_datetime()
  end

  def build_ending_date(_timezone, "week", current_date) do
    Timex.end_of_week(current_date) |> Timex.to_naive_datetime()
  end

  def current_from_params(timezone, %{"day" => day, "month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-#{day}", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(timezone)
    end
  end

  def current_from_params(timezone, %{"month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-01", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(timezone)
    end
  end

  def current_from_params(timezone, %{"day" => day, "month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-#{day}", "{YYYY}-{Wiso}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(timezone)
    end
  end

  def current_from_params(timezone, _) do
    Timex.today(timezone)
  end

  def date_to_day(date_time) do
    Timex.format!(date_time, "{D}")
  end

  def date_to_week(date_time) do
    Timex.format!(date_time, "{Wiso}")
  end

  def date_to_month(date_time) do
    Timex.format!(date_time, "{0M}")
  end

  def date_to_year(date_time) do
    Timex.format!(date_time, "{YYYY}")
  end

  def get_date_activities(activities, date) do
    activities
    |> Enum.filter(&(NaiveDateTime.to_date(&1.start) == date))
    |> Enum.sort_by(& &1.start, {:asc, NaiveDateTime})
  end
end
