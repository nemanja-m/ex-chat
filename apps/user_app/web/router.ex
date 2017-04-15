defmodule UserApp.Router do
  use UserApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", UserApp do
    pipe_through :api

    get    "/users",          UserController, :index
    post   "/users/register", UserController, :create
    delete "/users/:id",      UserController, :delete

    post   "/sessions", SessionController, :create
    delete "/sessions", SessionController, :delete
  end
end
