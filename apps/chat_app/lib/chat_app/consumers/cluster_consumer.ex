defmodule ChatApp.ClusterConsumer do
  use Tackle.Consumer,
    url: Application.get_env(:chat_app, :rabbitmq_url),
    exchange: ChatApp.ClusterHandler.exchange_name(ChatApp.Config.alias),
    routing_key: "cluster-event",
    service: "#{ChatApp.Config.alias}"

  alias ChatApp.{Config, Cluster, ClusterHandler, User}
  require Logger

  def handle_message(message) do
    message
    |> Poison.decode!
    |> process_message
  end

  defp process_message(%{"type" => "REGISTER_NODE", "payload" => node}) do
    case Cluster.register_node(node) do
      :ok ->
        ClusterHandler.update_cluster(node, Config.is_master?)

      :node_exists ->
        Logger.error "Node with alias: '#{node["alias"]}' already exists"
    end
  end
  defp process_message(%{"type" => "REGISTER_NODES", "payload" => nodes}) do
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
  defp process_message(%{"type" => "UNREGISTER_NODE", "payload" => %{"alias" => aliaz}}) do
    Cluster.unregister_node aliaz

    if Config.is_master? do
      Cluster.nodes
      |> Enum.each(fn node ->
        ClusterHandler.publish_message(%{alias: aliaz}, "UNREGISTER_NODE", node.alias)
      end)
    end
  end
  defp process_message(_message), do: nil

end
