defmodule AppWeb.GlobalHelpers do

  @doc """
  Calculate pick up date based on user pick up date preference.
  """
  def calculate_pickup_date(date) do
    case Date.diff(Date.utc_today(), date) do
      0 -> "Today"
      -1 -> "Tomorrow"
      -2 -> "Next Day"
      _ -> "Lapsed Already"
    end
  end

  @doc """
  Calculate expected book return date from release date and lend duration.
  """
  def calculate_return_date(release_date, lend_duration) do
    Date.add(release_date, lend_duration)
  end

  @doc """
  Accepts a timestamp and return date year, month and day..
  """
  def get_date(date) do
    "#{date.year}-#{date.day}-#{date.month}"
  end

  def announcement do
    announcement = App.Query.Announcement.list_announcements
    if announcement == [] do
      0
    else
      announcement.id
    end
  end

  @doc """
  Calculate the penalty of the borrower based on the lapsed days at 50 per day.
  """
  def calculate_penalty(release_date, lend_duration) do
    days = Date.diff(calculate_return_date(release_date, lend_duration), Date.utc_today())
    if days < 0 do
      abs(days) * 50 # penalty is days * 50
    else
      "N/A"
    end
  end

  def enum_with_index(list) do
    Enum.with_index(list)
  end

  def username(firstname, lastname) do
    firstname <> " " <> lastname
  end

  def company_name do
    "Philippine Christian University"
  end

  @doc """
  Strips scripts embedded in string.
  """
  def strip_script(data) do
    data
    |> String.replace(~r/<script>/i, "&lt;script&gt;")
    |> String.replace(~r/<\/script>/i, "&lt;/script&gt;")
  end

  @doc """
  Converts plain text to html.
  """
  def as_html(string) do
    case App.as_html(string) do
      {:ok, data, _list} ->
        data
	|> strip_script()
      {:error, _msg, _list} ->
        "Something went wrong!"
    end
  end
end