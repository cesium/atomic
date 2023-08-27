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

  @doc ~S"""
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

  def table_opts do
    [
      no_results_content: content_tag(:p, "Nothing found.", class: "text-center py-5"),
      table_attrs: [class: "min-w-full divide-y divide-gray-300 h-[70vh] overflow-auto border-1"],
      thead_tr_attrs: [class: "bg-gray-50 select-none"],
      thead_th_attrs: [
        class: "py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6",
        scope: "col"
      ],
      tbody_td_attrs: [
        class: "whitespace-nowrap px-3 py-4 text-sm text-gray-500 border-b-[1px] sm:pl-6"
      ]
    ]
  end

  def pagination_opts do
    [
      ellipsis_content: "...",
      ellipsis_attrs: [
        class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500"
      ],
      page_links: {:ellipsis, 3},
      pagination_link_attrs: [
        class:
          "inline-flex items-center px-4 pt-4 text-sm font-medium text-gray-500 hover:text-gray-700 select-none"
      ],
      current_link_attrs: [
        class: "inline-flex items-center px-4 pt-4 text-sm font-medium text-secondary select-none"
      ],
      pagination_list_attrs: [class: "flex flex-row"],
      next_link_attrs: [
        class:
          "inline-flex items-center pt-4 pr-1 text-sm font-medium text-gray-500 hover:text-gray-700 order-last select-none cursor-pointer"
      ],
      next_link_content: next_icon(),
      previous_link_attrs: [
        class:
          "inline-flex items-center pt-4 pr-1 text-sm font-medium text-gray-500 hover:text-gray-700 select-none cursor-pointer"
      ],
      previous_link_content: previous_icon(),
      wrapper_attrs: [class: "flex justify-between items-center px-4 mb-5 w-full select-none"]
    ]
  end

  defp previous_icon() do
    raw(
      "<svg class=\"mr-3 w-5 h-5\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 20 20\" fill=\"currentColor\" aria-hidden=\"true\">
    <path fill-rule=\"evenodd\" d=\"M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z\" clip-rule=\"evenodd\"></path>
    </svg>"
    )
  end

  defp next_icon() do
    raw(
      "<svg class=\"ml-3 w-5 h-5\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 20 20\" fill=\"currentColor\" aria-hidden=\"true\">
    <path fill-rule=\"evenodd\" d=\"M12.293 5.293a1 1 0 011.414 0l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 010-2h11.586l-2.293-2.293a1 1 0 010-1.414z\" clip-rule=\"evenodd\"></path>
    </svg>"
    )
  end
end
