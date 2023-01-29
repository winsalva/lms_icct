defmodule AppWeb.SharedView do
  use AppWeb, :view

  alias App.Query.{User, Lend}
  
  def get_new_registered_unseen_user_accounts do
    User.get_new_registered_unseen_accounts()
    |> length()
  end

  def get_list_requested_books do
    Lend.list_requested_books()
    |> length()
  end

  def count_approved_user_requested_books(user_id) do
    Lend.user_has_approved_requested_books(user_id)
  end
end