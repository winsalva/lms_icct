defmodule AppWeb.GlobalHelpers do

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

  def calculate_penalty(expected_date, date_returned) do
    cond do
      date_returned != nil ->
        if Date.compare(expected_date, date_returned) == :gt do
	  0
	else
	  y = (date_returned.year - expected_date.year) * 365
	  m = (date_returned.month - expected_date.month) * 30
	  d = date_returned.day - expected_date.day
	  (y + m + d) * 50
	end
      date_returned == nil ->
        if Date.compare(expected_date, Date.utc_today) == :gt do
	  0
	else
	  y = (date_returned.year - expected_date.year) * 365
          m = (date_returned.month - expected_date.month) * 30
          d = date_returned.day - expected_date.day
          (y + m + d) * 50
        end
      true ->
        0
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