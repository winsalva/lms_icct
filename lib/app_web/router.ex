defmodule AppWeb.Router do
  use AppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AppWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AppWeb do
    pipe_through :browser

    get "/*fallback", PageController, :fallback

    get "/", PageController, :index
    get "/users/all", PageController, :users
    post "/users/all", PageController, :search_users
    get "/books/all", PageController, :books
    post "/books/all", PageController, :search_books
    get "/transactions/all", PageController, :transactions
    get "/home", PageController, :home
    get "/terms-of-use", PageController, :term_of_use
    get "/privacy-policy", PageController, :privacy_policy
    get "/menus", PageController, :menus
    get "/about-us", PageController, :about_us
    get "/contact-us", PageController, :contact_us
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

  end


  ## Announcement Routes
  
  scope "/announcements", AppWeb.Announcement, as: :announcement do
    pipe_through :browser

    resources "/", PageController

  end
 

  ## User Routes
  
  scope "/users", AppWeb.User, as: :user do
    pipe_through :browser

    resources "/", PageController, only: [
      :index, :new, :create
    ]
    
    resources "/accounts", AccountController, only: [:new, :create, :show, :delete]

    get "/transactions/:user_id", AccountController, :user_transactions
    get "/accounts/:id/edit-name", AccountController, :edit_name
    put "/accounts/edit-name", AccountController, :update_name
    get "/accounts/:id/change-password", AccountController, :change_password
    put "/accounts/change-password", AccountController, :update_password
    post "/accounts/approves/:id", AccountController, :approve_disapprove_user
    post "/accounts/reset-password/:id", AccountController, :reset_password
  end


  ## Book Routes

  scope "/books", AppWeb.Book, as: :book do
    pipe_through :browser

    resources "/", PageController
    post "/add/new", PageController, :create_book

  end

  ## Lend Routes

  scope "/lends", AppWeb.Lend, as: :lend do
    pipe_through :browser

    get "/new/:book_id", PageController, :new
    post "/", PageController, :create
    get "/", PageController, :index
    get "/books/:id", PageController, :return_lend
    get "/penalty/reports", PageController, :penalty_report
    get "/books/return-lended-book/:id", PageController, :return_lended_book
    post "/books/approve-requests/:id", PageController, :approve_request
    post "/books/reject-requests/:book_id/:id", PageController, :reject_request
    post "/books/release-books/:book_id/:id", PageController, :release_book
    post "/books/lends/return-conditions/:book_id/:id", PageController, :return_book_condition
    post "/books/return-book", PageController, :return_book
    post "/books/return-overdue-book/:book_id/:id", PageController, :return_overdue_book
    get "/requested-books", PageController, :requested_books
    get "/approved-requested-books", PageController, :approved_requested_books
    get "/released-books", PageController, :released_books
    get "/returned-books", PageController, :returned_books
    get "/overdue-books", PageController, :overdue_books
    get "/out-of-stock-books", PageController, :out_of_stock_books

  end


  ## Admin Routes

  scope "/admins", AppWeb.Admin, as: :admin do
    pipe_through :browser

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    get "/list-admins", PageController, :list_admins
    get "/list-reservations", PageController, :list_reservations
    resources "/", PageController, only: [
      :index, :new, :create, :show, :edit, :update, :delete
    ]

     get "/accounts/:id/edit-username", AccountController, :edit_username
     put "/accounts/update-username", AccountController, :update_username
     get "/accoutns/:id/change-password", AccountController, :change_password
     put "/accounts/update-password", AccountController, :update_password

  end


  # Other scopes may use custom stacks.
  # scope "/api", AppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
    end
  end
end
