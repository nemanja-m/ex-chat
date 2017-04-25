defmodule UserApp.SessionController do
  use UserApp.Web, :controller

  alias UserApp.{Auth, User, Repo}

  def create(conn, %{"username" => username, "password" => password, "host" => host}) do
    conn
    |> Auth.login(username, password, host)
    |> create_login_response
  end

  def delete(conn, _params) do
    Guardian.Plug.current_token(conn)
    |> Guardian.revoke!

    conn
    |> delete_host_from_user
    |> put_status(:ok)
    |> render("delete.json", success: true)
  end

  defp create_login_response({conn, :ok, user}) do
    conn = Guardian.Plug.api_sign_in(conn, user, :access)
    jwt  = Guardian.Plug.current_token(conn)

    conn
    |> put_status(:ok)
    |> render("show.json", user: user, jwt: jwt)
  end

  defp create_login_response({conn, :error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json", reason: "Invalid password")
  end

  defp create_login_response({conn, :error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render("error.json", reason: "User does not exist")
  end

  defp delete_host_from_user(conn) do
    user = Guardian.Plug.current_resource(conn)

    User.host_changeset(user, %{host_id: nil})
    |> Repo.update!

    conn
  end
end
