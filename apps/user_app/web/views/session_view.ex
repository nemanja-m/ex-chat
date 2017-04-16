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

  def render("delete.json", %{success: success}) do
    %{data: %{success: success}}
  end
end
