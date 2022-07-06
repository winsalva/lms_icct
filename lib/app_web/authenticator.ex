defmodule AppWeb.Authenticator do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    admin =
      get_session(conn, :admin_id)
      |> case do
        nil -> nil
        admin_id -> App.Query.Admin.get_admin(admin_id)
      end

    user =
      get_session(conn, :user_id)
      |> case do
        nil -> nil
        user_id -> App.Query.User.get_user(user_id)
      end


    cond do
      admin != nil and user != nil ->
        conn
        |> assign(:current_admin, admin)
        |> assign(:current_user, nil)
	
      admin != nil and user == nil ->
        conn
        |> assign(:current_admin, admin)
        |> assign(:current_user, nil)

      admin == nil and user != nil ->
        #lends = App.Query.Lend.user_has_approved_requested_books(user.id)
        conn
        |> assign(:current_admin, nil)
        |> assign(:current_user, user)
	#|> assign(:lends, lends)

      true ->
        conn
        |> assign(:current_admin, nil)
        |> assign(:current_user, nil)
    end
  end
end