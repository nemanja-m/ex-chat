defmodule ChatApp.ClusterConsumer do
  use Tackle.Consumer,
    url: Application.get_env(:chat_app, :rabbitmq_url),
    exchange: ChatApp.ClusterHandler.exchange_name(ChatApp.Config.alias),
    routing_key: "cluster-event",
    service: "#{ChatApp.Config.alias}"

  alias ChatApp.ClusterHandler

  def handle_message(message) do
    message
    |> Poison.decode!
    |> process_message
  end

  defp process_message(message) do
    case message do
      %{"type" => "REGISTER_NODE", "payload" => node} ->
        ClusterHandler.register_node(node)

      %{"type" => "REGISTER_NODES", "payload" => nodes} ->
        ClusterHandler.register_nodes(nodes)

      %{"type" => "UNREGISTER_NODE", "payload" => %{"alias" => aliaz}} ->
        ClusterHandler.unregister_node(aliaz)

      %{"type" => "ADD_USER", "payload" => %{"data" => data}} ->
        ClusterHandler.add_user(data)

      %{"type" => "REMOVE_USER", "payload" => %{"alias" => aliaz, "id" => id}} ->
        ClusterHandler.remove_user(aliaz, id)

        _ -> nil
    end
  end

end
