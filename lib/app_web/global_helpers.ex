defmodule AppWeb.GlobalHelpers do

  def enum_with_index(list) do
    Enum.with_index(list)
  end

  def company_name do
    "JG Brokerage"
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
  Converts plain to to html.
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