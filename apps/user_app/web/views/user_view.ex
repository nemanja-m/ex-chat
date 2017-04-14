defmodule UserApp.UserView do
  use UserApp.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserApp.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserApp.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      password: user.password,
      password_hash: user.password_hash}
  end
end
