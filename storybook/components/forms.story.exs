defmodule AtomicWeb.Storybook.Components.Forms do
  use PhoenixStorybook.Story, :component

  alias AtomicWeb.Components.Forms

  def function, do: &Forms.field/1

  def template do
    """
    <.form id="form" :let={form} for={%{}}>
      <.lsb-variation field={form[:default]}/>
    </.form>
    """
  end

  def variations do
    [
      %Variation{
        id: :text,
        attributes: %{
          label: "Text",
          type: "text",
          placeholder: "Text"
        }
      },
      %Variation{
        id: :select,
        attributes: %{
          label: "Select",
          type: "select",
          options: ["Option 1", "Option 2", "Option 3"]
        }
      },
      %Variation{
        id: :checkbox_group,
        attributes: %{
          label: "Checkbox group",
          type: "checkbox-group",
          options: [{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]
        }
      },
      %Variation{
        id: :radio_group,
        attributes: %{
          label: "Radio group",
          type: "radio-group",
          options: [{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]
        }
      },
      %Variation{
        id: :switch,
        attributes: %{
          label: "Switch",
          type: "switch"
        }
      },
      %Variation{
        id: :checkbox,
        attributes: %{
          label: "Checkbox",
          type: "checkbox"
        }
      },
      %Variation{
        id: :color,
        attributes: %{
          label: "Color",
          type: "color"
        }
      },
      %Variation{
        id: :date,
        attributes: %{
          label: "Date",
          type: "date"
        }
      },
      %Variation{
        id: :datetime,
        attributes: %{
          label: "Datetime",
          type: "datetime-local"
        }
      },
      %Variation{
        id: :email,
        attributes: %{
          label: "Email",
          type: "email"
        }
      },
      %Variation{
        id: :file,
        attributes: %{
          label: "File",
          type: "file"
        }
      },
      %Variation{
        id: :month,
        attributes: %{
          label: "Month",
          type: "month"
        }
      },
      %Variation{
        id: :number,
        attributes: %{
          label: "Number",
          type: "number"
        }
      },
      %Variation{
        id: :password,
        attributes: %{
          label: "Password",
          type: "password"
        }
      },
      %Variation{
        id: :range,
        attributes: %{
          label: "Range",
          type: "range"
        }
      },
      %Variation{
        id: :search,
        attributes: %{
          label: "Search",
          type: "search"
        }
      },
      %Variation{
        id: :telephone,
        attributes: %{
          label: "Telephone",
          type: "tel"
        }
      },
      %Variation{
        id: :time,
        attributes: %{
          label: "Time",
          type: "time"
        }
      },
      %Variation{
        id: :url,
        attributes: %{
          label: "URL",
          type: "url"
        }
      },
      %Variation{
        id: :week,
        attributes: %{
          label: "Week",
          type: "week"
        }
      }
    ]
  end
end
