defmodule AtomicWeb.Helpers do
  @moduledoc """
  A module with helper functions to display data in views
  """
  use Phoenix.HTML

  import AtomicWeb.Gettext

  alias Timex.Format.DateTime.Formatters.Relative

  require Timex.Translator

  @doc """
    Returns the frontend url from the config.
  """
  def frontend_url do
    Application.fetch_env!(:atomic, AtomicWeb.Endpoint)[:frontend_url]
  end

  @doc """
  Returns a relative datetime string for the given datetime.

  ## Examples

      iex> relative_datetime(~N[2020-01-01 00:00:00])
      "3 years ago"

      iex> relative_datetime(~N[2023-01-01 00:00:00] |> Timex.shift(days: 1))
      "7 months ago"

  """
  def relative_datetime(nil), do: ""

  def relative_datetime(""), do: ""

  def relative_datetime(datetime) do
    Relative.lformat!(datetime, "{relative}", Gettext.get_locale())
  end

  @doc """
  Returns a relative date string for the given date.

  ## Examples

      iex> display_date(~D[2020-01-01])
      "01-01-2020"

      iex> display_date(~D[2023-01-01])
      "01-01-2023"

  """
  def display_date(nil), do: ""

  def display_date(""), do: ""

  def display_date(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_date(date) do
    Timex.format!(date, "{0D}-{0M}-{YYYY}")
  end

  @doc """
  Returns a relative time string for the given time.

  ## Examples

      iex> display_time(~T[00:00:00])
      "00:00"

      iex> display_time(~T[23:59:59])
      "23:59"
  """
  def display_time(nil), do: ""

  def display_time(""), do: ""

  def display_time(date) when is_binary(date) do
    date
    |> Timex.parse!("%FT%H:%M", :strftime)
    |> Timex.format!("{0D}-{0M}-{YYYY}")
  end

  def display_time(date) do
    date
    |> Timex.format!("{h24}:{m}")
  end

  @doc """
    Returns a list of first element from tuples where the second element is true

    ## Examples

        iex> class_list([{"col-start-1", true}, {"col-start-2", false}, {"col-start-3", true}])
        "col-start-1 col-start-3"

        iex> class_list([{"Math", true}, {"Physics", false}, {"Chemistry", false}])
        "Math"
  """
  def class_list(items) do
    items
    |> Enum.reject(&(elem(&1, 1) == false))
    |> Enum.map_join(" ", &elem(&1, 0))
  end

  @doc """
    Returns the class name for a given column

    ## Examples

        iex> col_start(1)
        "col-start-1"

        iex> col_start(2)
        "col-start-2"

        iex> col_start(0)
        "col-start-0"

        iex> col_start(8)
        "col-start-0"
  """
  def col_start(col) do
    if col in 1..7 do
      "col-start-#{col}"
    else
      "col-start-0"
    end
  end

  @doc """
    Returns the string with the first letter capitalized

    ## Examples

        iex> capitalize_first_letter(:hello)
        "Hello"

        iex> capitalize_first_letter(:world)
        "World"
  """
  def capitalize_first_letter(string) do
    if is_nil(string) do
      ""
    else
      string
      |> Atom.to_string()
      |> String.capitalize()
    end
  end

  @doc """
    Returns the current academic year

    ## Examples

        iex> build_current_academic_year()
        "2022/2023"
  """
  @spec build_current_academic_year() :: String.t()
  def build_current_academic_year do
    now = Date.utc_today()
    start_year = calculate_academic_start_year(now)

    "#{start_year}/#{start_year + 1}"
  end

  @doc """
    Returns the start year of the academic year of a given date

    ## Examples

        iex> calculate_academic_start_year(~D[2020-01-01])
        2019

        iex> calculate_academic_start_year(~D[2020-09-01])
        2020

        iex> calculate_academic_start_year(~D[2022-05-31])
        2021

        iex> calculate_academic_start_year(~D[2022-08-31])
        2021

        iex> calculate_academic_start_year(~D[2023-12-05])
        2023
  """
  @spec calculate_academic_start_year(Date.t()) :: integer()
  def calculate_academic_start_year(date) do
    current_year = date.year
    next_year = current_year + 1

    academic_year_start = Timex.parse!("01-09-#{current_year}", "{0D}-{0M}-{YYYY}")
    academic_year_end = Timex.parse!("31-08-#{next_year}", "{0D}-{0M}-{YYYY}")

    if Timex.between?(date, academic_year_start, academic_year_end, inclusive: true) do
      current_year
    else
      current_year - 1
    end
  end

  def build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  @doc """
    Appends two lists when a condition is true

    ## Examples

        iex> append_if([1, 2, 3], true, [4])
        [1, 2, 3, 4]

        iex> append_if([1, 2, 3], false, [4])
        [1, 2, 3]

        iex> append_if([1, 2, 3], false, [4])
        [1, 2, 3]

        iex> append_if([1, 2, 3], true, [4, 5, 6])
        [1, 2, 3, 4, 5, 6]
  """
  def append_if(list, condition, item) when is_list(item) do
    if condition do
      list ++ item
    else
      list
    end
  end

  @doc """
    Returns an error message for a given error

    ## Examples

        iex> error_to_string(:too_large)
        "Too large"

        iex> error_to_string(:not_accepted)
        "You have selected an unacceptable file type"

        iex> error_to_string(:too_many_files)
        "You have selected too many files"
  """
  def error_to_string(:too_large), do: gettext("Too large")
  def error_to_string(:not_accepted), do: gettext("You have selected an unacceptable file type")
  def error_to_string(:too_many_files), do: gettext("You have selected too many files")
end
