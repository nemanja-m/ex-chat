defmodule UserApp.UserView do
  use UserApp.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserApp.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserApp.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    hash = %{id: user.id, username: user.username}

    case user.host_id do
      nil -> hash
      _   -> Map.merge(hash, %{host: user.host})
    end
  end
end
