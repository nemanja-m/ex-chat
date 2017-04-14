defmodule UserApp.Router do
  use UserApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UserApp do
    pipe_through :api

    resources "/users", UserController
  end
end
