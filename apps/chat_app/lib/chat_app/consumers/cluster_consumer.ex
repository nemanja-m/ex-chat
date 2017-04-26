defmodule ChatApp.ClusterConsumer do
  use Tackle.Consumer,
    url: Application.get_env(:chat_app, :rabbitmq_url),
    exchange: ChatApp.ClusterHandler.exchange_name(ChatApp.Config.alias),
    routing_key: "cluster-event",
    service: "#{ChatApp.Config.alias}"

  defmodule ClusterError do
    defexception message: "Cluser error"
  end

  alias ChatApp.{Config, Cluster, ClusterHandler}

  def handle_message(message) do
    message
    |> Poison.decode!
    |> parse_message
  end

  defp parse_message(%{"type" => "REGISTER_NODE", "payload" => node}) do
    case Cluster.register_node(node) do
      :ok ->
        ClusterHandler.update_cluster(node, Config.is_master?)

      :node_exists ->
        raise ClusterError, message: "Node with alias: '#{node["alias"]}' exists"
    end
  end
  defp parse_message(_message), do: nil

end
