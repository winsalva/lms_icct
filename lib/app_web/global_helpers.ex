defmodule AppWeb.GlobalHelpers do

  def user_has_approved_requested_books(user_id) do
    App.Query.Lend.user_has_approved_requested_books(user_id)
  end

  def get_class_status(status) do
    case status do
      "Requested" -> "color-lightblue"
      "Approved" -> "color-lightblue"
      "Released" -> "color-green"
      "Returned" -> "color-yellow"
      "Rejected" -> "color-red"
      "Overdue" -> "color-red"
      _ -> "color-lightblue"
    end
  end

  def tomorrow do
    date = Date.add(Date.utc_today, 1)
    "#{date.year}-#{date.month}-#{date.day}"
  end

  def next_day do
    date = Date.add(Date.utc_today, 2)
    "#{date.year}-#{date.month}-#{date.day}"
  end

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
    "#{date.month}-#{date.day}-#{date.year}"
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
  Calculate the penalty of the borrower based on the lapsed days at 1 per day.
  """
  def calculate_penalty(release_date, lend_duration) do
    days = Date.diff(calculate_return_date(release_date, lend_duration), Date.utc_today())
    penalty =
    if days < 0 do
      abs(days) * 1 # penalty is days * 1
    else
      0
    end

    penalty
  end

  @doc """
  Calculate penalty including book condition
  """
  def calculate_penalty2(release_date, lend_duration, book_condition) do
    book_condition_penalty =
      case book_condition do
        "Good Condition" -> 0
	"Partly Damage" -> 50
	"Totally Damage" -> 100
	_ -> 0
      end

    result =
      if calculate_penalty(release_date, lend_duration) == nil || calculate_penalty(release_date, lend_duration) <= 0 do
        0 + book_condition_penalty
      else
        calculate_penalty(release_date, lend_duration) + book_condition_penalty
      end

    result
  end   

  def enum_with_index(list) do
    Enum.with_index(list)
  end

  def username(firstname, lastname) do
    firstname <> " " <> lastname
  end

  def company_name do
    "SCHOOL NAME"
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