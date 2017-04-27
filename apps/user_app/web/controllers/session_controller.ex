defmodule UserApp.SessionController do
  use UserApp.Web, :controller

  alias UserApp.{Auth, User, Repo}

  def index(conn, _params) do
    users =
      User
      |> where([user], not is_nil(user.host_id))
      |> Repo.all
      |> Repo.preload(:host)

    conn
    |> put_status(:ok)
    |> render(UserApp.UserView, "index.json", users: users)
  end

  def create(conn, %{"username" => username, "password" => password, "host" => host}) do
    conn
    |> Auth.login(username, password, host)
    |> notify_master_node
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

  # Publish message to master's exchange. After master ChatApp receives
  # this message, it will publish 'ADD_USER' message to rest of the cluster.
  defp notify_master_node({conn, :ok, user}) do
    master_alias = Application.get_env(:user_app, :master_alias)

    options = %{
      url: Application.get_env(:user_app, :rabbitmq_url),
      exchange: "#{String.downcase(master_alias)}-exchange",
      routing_key: "cluster-event"
    }

    message = %{
      type: "ADD_USER",
      payload: user
    }

    Tackle.publish(Poison.encode!(message), options)

    {conn, :ok, user}
  end
  defp notify_master_node(params), do: params

end
