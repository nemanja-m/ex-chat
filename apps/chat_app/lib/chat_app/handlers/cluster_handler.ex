defmodule ChatApp.ClusterHandler do
  require Logger

  alias ChatApp.{Config, Cluster, User}

  @doc """
  Notify rest of cluster that new node is registered. Also, returns
  list of current nodes in cluster to the new node ( sender ).
  """
  def register_node(node) do
    case Cluster.register_node(node) do
      :ok ->
        update_cluster(node, Config.is_master?)
        Logger.info "Node '#{node["alias"]}' registered to cluster."

      :node_exists ->
        Logger.error "Node '#{node["alias"]}' already exists."
    end
  end

  def register_nodes(nodes) do
    nodes
    |> Enum.each(fn node ->
      Cluster.register_node(node)
    end)

    # Get list of all active users and map them to corresponding nodes in cluster.
    response = HTTPoison.get!("#{Config.master_node_url}/sessions")

    Poison.decode!(response.body)["data"]
    |> Enum.each(fn %{"host" => host, "id" => id, "username" => username} ->
      Cluster.add_user(host["alias"], %User{id: id, username: username})
    end)
  end

  def unregister_node(aliaz) do
    Cluster.unregister_node aliaz

    if Config.is_master? do
      Cluster.nodes
      |> Enum.reject(fn node -> Config.alias() == node.alias end)
      |> Enum.each(fn node ->
        publish_message(%{alias: aliaz}, "UNREGISTER_NODE", node.alias)
      end)
    end

    Logger.warn "Node '#{aliaz}' unregistered from cluster."
  end

  @doc """
  Add new logged user to cluster and update connected users.
  """
  def add_user(user = %{"host" => host, "id" => id, "username" => username}) do
    %{"alias" => aliaz, "address" => _addr} = host

    case Cluster.add_user(aliaz, %User{id: id, username: username}) do
      :ok ->
        ChatApp.Endpoint.broadcast! "room:lobby", "user:login", %{id: id, username: username}

        # Publish 'ADD_USER' message to other nodes when current node is master.
        notify_cluster_for_new_user(user, Config.is_master?)

        Logger.info "User '#{username}' logged in @#{aliaz}."

      :node_missing ->
        Logger.error "Node '#{aliaz}' does not exist!"
    end
  end

  def remove_user(aliaz, id) do
    case Cluster.remove_user(aliaz, id) do
      {:ok, %{id: _id, username: username}} ->
        ChatApp.Endpoint.broadcast! "room:lobby", "user:logout", %{id: id, username: username}

        notify_cluster_for_removed_user(aliaz, id, Config.is_master?)
        Logger.warn "User '#{username}' logged out @#{aliaz}."

      {:error, :user_not_found} ->
        Logger.error "User #{id} not found @#{aliaz}."

      {:error, :node_not_found} ->
        Logger.error "Node @#{aliaz} not found."
    end
  end

  @doc """
  Returns exhange name for given node's alias.
  """
  def exchange_name(aliaz) do
    "#{aliaz |> String.downcase}-exchange"
  end

  @doc """
  Register this (non-master) node at cluster.
  'REGISTER_NODE' request is sent to master exchange.
  """
  def register_self do
    unless Config.is_master? do
      publish_message(Config.this, "REGISTER_NODE", Config.master_node_alias)
    end
  end

  defp update_cluster(node = %{"alias" => aliaz, "address" => _addr}, true) do
    update_sender(aliaz)
    notify_cluster(node)
  end
  defp update_cluster(_params, false), do: nil

  defp publish_message(payload, type, receiver) do
    message = %{
      type: type,
      payload: payload
    }

    options = publish_options(receiver)

    Tackle.publish(Poison.encode!(message), options)
  end

  defp update_sender(sender) do
    available_nodes_for(sender)
    |> publish_message("REGISTER_NODES", sender)
  end

  defp notify_cluster(node = %{"alias" => aliaz, "address" => _addr}) do
    available_nodes_for(aliaz)
    |> Enum.reject(fn nod -> nod.alias == Config.alias() end)
    |> Enum.map(&Task.async fn ->
      publish_message(node, "REGISTER_NODE", &1[:alias])
    end)
    |> Enum.map(&Task.await/1)
  end

  defp available_nodes_for(aliaz) do
    # Returns all nodes in cluster except for input node.

    Cluster.nodes
    |> Enum.reject(fn node -> node.alias == aliaz end)
    |> Enum.map(fn node -> node |> Map.from_struct |> Map.drop([:users]) end)
  end

  defp publish_options(aliaz) do
    %{
      url: Application.get_env(:chat_app, :rabbitmq_url),
      exchange: exchange_name(aliaz),
      routing_key: "cluster-event"
    }
  end

  defp notify_cluster_for_new_user(user, true) do
    Cluster.nodes
    |> Enum.reject(fn node -> node.alias == Config.alias() end)
    |> Enum.map(&Task.async fn ->
      publish_message(%{data: user}, "ADD_USER", &1[:alias])
    end)
    |> Enum.map(&Task.await/1)
  end
  defp notify_cluster_for_new_user(_, false), do: nil

  defp notify_cluster_for_removed_user(aliaz, id, true) do
    Cluster.nodes
    |> Enum.reject(fn node -> Config.alias() == node.alias end)
    |> Enum.map(&Task.async fn ->
      publish_message(%{alias: aliaz, id: id}, "REMOVE_USER", &1[:alias])
    end)
    |> Enum.map(&Task.await/1)
  end
  defp notify_cluster_for_removed_user(_, _, false), do: nil

end
