defmodule ChatApp.MessageConsumer do
  use Tackle.Consumer,
    url: Application.get_env(:chat_app, :rabbitmq_url),
    exchange: ChatApp.ClusterHandler.exchange_name(ChatApp.Config.alias),
    routing_key: "message-event",
    service: "#{ChatApp.Config.alias}"

  def handle_message(message) do
    message
    |> Poison.decode!
    |> process_message
  end

  defp process_message(message) do
    ChatApp.Endpoint.broadcast! "room:lobby", "message:new", message
  end
end
