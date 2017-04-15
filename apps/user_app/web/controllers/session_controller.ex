defmodule UserApp.SessionController do
  use UserApp.Web, :controller

  alias UserApp.Auth

  def create(conn, %{"username" => username, "password" => password}) do
    conn
    |> create_login_response(Auth.login(username, password))
  end

  defp create_login_response(conn, {:ok, user}) do
    conn = Guardian.Plug.api_sign_in(conn, user, :access)
    jwt  = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end

  defp create_login_response(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json", reason: "Invalid password")
  end

  defp create_login_response(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("error.json", reason: "User does not exist")
  end
end
