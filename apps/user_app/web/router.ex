defmodule UserApp.Router do
  use UserApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UserApp do
    pipe_through :api

    get    "/users",          UserController, :index
    post   "/users/register", UserController, :create
    delete "/users/:id",      UserController, :delete
  end
end
