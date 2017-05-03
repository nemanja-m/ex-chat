defmodule ChatApp.MessageHandler do
  alias ChatApp.Cluster
  require Logger

  def send_public(message) do
    nodes()
    |> Enum.map(&Task.async fn -> publish_message(&1, message) end)
    |> Enum.map(&Task.await/1)
  end

  def send_private(message) do
    node =
      message["receiver"]
      |> Cluster.find_node

    case node do
      nil ->
        Logger.error "#{message["receiver"]} not found."

      aliaz ->
        publish_message(aliaz, message)
        Logger.warn "Sending message to #{message["receiver"]}@#{node}."
    end
  end

  defp nodes do
    Cluster.nodes
    |> Enum.map(fn node -> node.alias end)
  end

  defp publish_message(receiver, message) do
    options = publish_options(receiver)

    Tackle.publish(Poison.encode!(message), options)
  end

  defp publish_options(aliaz) do
    %{
      url: Application.get_env(:chat_app, :rabbitmq_url),
      exchange: ChatApp.ClusterHandler.exchange_name(aliaz),
      routing_key: "message-event"
    }
  end

end
