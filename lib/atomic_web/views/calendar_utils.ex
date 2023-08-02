defmodule AtomicWeb.CalendarUtils do
  @moduledoc """
  Calendar utils functions to be used on all views.
  """
  use Phoenix.HTML
  use Timex

  def current_from_params(time_zone, %{"day" => day, "month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-#{day}", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(time_zone)
    end
  end

  def current_from_params(time_zone, %{"month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-01", "{YYYY}-{0M}-{D}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(time_zone)
    end
  end

  def current_from_params(time_zone, %{"day" => day, "month" => month, "year" => year}) do
    case Timex.parse("#{year}-#{month}-#{day}", "{YYYY}-{Wiso}") do
      {:ok, current} ->
        NaiveDateTime.to_date(current)

      _ ->
        Timex.today(time_zone)
    end
  end

  def current_from_params(time_zone, _) do
    Timex.today(time_zone)
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

  def get_date_sessions(sessions, date) do
    sessions
    |> Enum.filter(&(NaiveDateTime.to_date(&1.start) == date))
    |> Enum.sort_by(& &1.start, {:asc, NaiveDateTime})
  end
end
