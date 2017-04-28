defmodule ChatApp.MessageHandler do
  alias ChatApp.Cluster

  def send_public(message) do
    nodes
    |> Enum.each(fn node -> publish_message(node, message) end)
  end

  def send_private(message) do
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
