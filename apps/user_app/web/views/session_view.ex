defmodule UserApp.SessionView do
  use UserApp.Web, :view

  def render("show.json", %{user: user, jwt: jwt}) do
    %{
      data: %{
        user: render_one(user, UserApp.UserView, "user.json"),
        token: jwt
      }
    }
  end

  def render("error.json", %{reason: reason}) do
    %{error: reason}
  end
end
