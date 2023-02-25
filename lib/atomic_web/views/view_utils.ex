defmodule AtomicWeb.ViewUtils do
  @moduledoc """
  Utility functions to be used on all views.
  """
  use Phoenix.HTML

  import AtomicWeb.Gettext

  alias Timex.Format.DateTime.Formatters.Relative

  @spec extract_initials(nil | String.t()) :: String.t()
  def extract_initials(nil), do: ""

  def extract_initials(name) do
    initials =
      name
      |> String.upcase()
      |> String.split(" ")
      |> Enum.map(&String.slice(&1, 0, 1))
      |> Enum.filter(&String.match?(&1, ~r/^\p{L}$/u))

    case length(initials) do
      0 -> ""
      1 -> hd(initials)
      _ -> List.first(initials) <> List.last(initials)
    end
  end

  @spec extract_first_last_name(nil | String.t()) :: String.t()
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

  def relative_datetime(nil), do: ""

  def relative_datetime(""), do: ""

  def relative_datetime(datetime) do
    Relative.lformat!(datetime, "{relative}", Gettext.get_locale())
  end

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

  def class_list(items) do
    items
    |> Enum.reject(&(elem(&1, 1) == false))
    |> Enum.map_join(" ", &elem(&1, 0))
  end

  def col_start(col) do
    case col do
      1 -> "col-start-1"
      2 -> "col-start-2"
      3 -> "col-start-3"
      4 -> "col-start-4"
      5 -> "col-start-5"
      6 -> "col-start-6"
      7 -> "col-start-7"
      _ -> "col-start-0"
    end
  end

  def build_path(current_path, params) do
    current_path
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(params))
    |> URI.to_string()
  end

  def error_to_string(:too_large), do: gettext("Too large")
  def error_to_string(:not_accepted), do: gettext("You have selected an unacceptable file type")
  def error_to_string(:too_many_files), do: gettext("You have selected too many files")

end
