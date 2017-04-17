defmodule ChatApp.Router do
  use ChatApp.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChatApp do
    pipe_through :api
  end
end
