defmodule AtomicWeb.Helpers do
  @moduledoc """
  A module with helper functions to display data in views
  """
  use Phoenix.HTML
  use Gettext, backend: AtomicWeb.Gettext

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

      iex> relative_datetime(Timex.today() |> Timex.shift(years: -3))
      "3 years ago"

      iex> relative_datetime(Timex.today() |> Timex.shift(years: 3))
      "in 3 years"

      iex> relative_datetime(Timex.today() |> Timex.shift(months: -8))
      "8 months ago"

      iex> relative_datetime(Timex.today() |> Timex.shift(months: 8))
      "in 8 months"

      iex> relative_datetime(Timex.today() |> Timex.shift(days: -1))
      "yesterday"

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
  Returns a pretty date string for the given date.

  ## Examples

      iex> pretty_display_date(~D[2020-01-01])
      "Wed, 1 Jan"

      iex> pretty_display_date(~D[2023-01-01])
      "Sun, 1 Jan"

      iex> pretty_display_date(~D[2023-01-01], "pt")
      "Dom, 1 de Jan"
  """
  def pretty_display_date(date, locale \\ "en")

  def pretty_display_date(date, "en" = locale) do
    Timex.Translator.with_locale locale do
      Timex.format!(date, "{WDshort}, {D} {Mshort}")
    end
  end

  def pretty_display_date(date, "pt" = locale) do
    Timex.Translator.with_locale locale do
      Timex.format!(date, "{WDshort}, {D} de {Mshort}")
    end
  end

  @doc """
  Returns :today if the given date is today, :this_week if the given date is within the current week, and :other otherwise.

  ## Examples

      iex> within_today_or_this_week(Timex.today())
      :today

      iex> within_today_or_this_week(Timex.today() |> Timex.shift(days: 1))
      :this_week

      iex> within_today_or_this_week(Timex.today() |> Timex.shift(days: 7))
      :this_week

      iex> within_today_or_this_week(Timex.today() |> Timex.shift(days: 8))
      :other
  """
  def within_today_or_this_week(date) do
    case Timex.diff(date, Timex.today(), :days) do
      0 -> :today
      days when days in 1..7 -> :this_week
      _ -> :other
    end
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
  Return the initials of a name.

  ## Examples

      iex> extract_initials("John Doe")
      "JD"

      iex> extract_initials("John")
      "J"

      iex> extract_initials(nil)
      ""

  """
  def extract_initials(nil), do: ""

  def extract_initials(name) do
    initials = name |> String.upcase() |> String.split(" ") |> Enum.map(&String.slice(&1, 0, 1))

    case length(initials) do
      1 -> hd(initials)
      _ -> List.first(initials) <> List.last(initials)
    end
  end

  @doc """
  Return the first and last name of a name.

  ## Examples

        iex> extract_first_last_name("John Doe")
        "John Doe"

        iex> extract_first_last_name("John")
        "John"

        iex> extract_first_last_name(nil)
        ""

  """
  def extract_first_last_name(nil), do: ""

  def extract_first_last_name(name) do
    names =
      name
      |> String.split(" ")
      |> Enum.filter(&String.match?(String.slice(&1, 0, 1), ~r/^\p{L}$/u))
      |> Enum.map(&String.capitalize/1)

    case length(names) do
      0 -> ""
      1 -> hd(names)
      _ -> List.first(names) <> " " <> List.last(names)
    end
  end

  @doc """
  Return the first name of a name.

  ## Examples

        iex> extract_first_name("John Doe")
        "John"

        iex> extract_first_name("John")
        "John"

        iex> extract_first_name(nil)
        ""

  """
  def extract_first_name(nil), do: ""

  def extract_first_name(name) do
    name
    |> String.split(" ")
    |> Enum.filter(&String.match?(String.slice(&1, 0, 1), ~r/^\p{L}$/u))
    |> Enum.map(&String.capitalize/1)
    |> hd()
  end

  @doc """
  Slices a string if it is longer than the given length

  ## Examples

        iex> maybe_slice_string("This is a very long string", 10)
        "This is a ..."

        iex> maybe_slice_string("This is a very long string", 30)
        "This is a very long string"

        iex> maybe_slice_string("This is a very long string")
        "This is a very long string"
  """
  @spec maybe_slice_string(String.t()) :: String.t()
  def maybe_slice_string(string, length \\ 30) do
    if String.length(string) > length do
      String.slice(string, 0, length) <> "..."
    else
      string
    end
  end

  @doc """
  Capitalizes the first letter of a string.

  ## Examples

        iex> capitalize_first_letter("hello")
        "Hello"

        iex> capitalize_first_letter("world")
        "World"

        iex> capitalize_first_letter(:hello)
        "Hello"

        iex> capitalize_first_letter(:world)
        "World"
  """
  def capitalize_first_letter(word) when is_atom(word) do
    word
    |> Atom.to_string()
    |> capitalize_first_letter()
  end

  def capitalize_first_letter(word) do
    word
    |> String.capitalize()
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

  def draw_qr_code(activity, user, _socket) do
    internal_route = "/redeem/#{activity.id}/#{user.id}/confirm"
    url = build_url() <> internal_route

    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end

  defp build_url do
    if Mix.env() == :dev do
      "http://localhost:4000"
    else
      "https://#{Application.fetch_env!(:atomic, AtomicWeb.Endpoint)[:url][:host]}"
    end
  end

  def build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  @doc ~S"""
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
