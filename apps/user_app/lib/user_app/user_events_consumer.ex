defmodule UserApp.UserEventsConsumer do
  use Tackle.Consumer,
    url: Application.get_env(:user_app, :rabbitmq_url),
    exchange: "user-app-exchange",
    routing_key: "user-events",
    service: "user-app"

  def handle_message(message) do
    IO.puts "Message received. Life is good!"

    IO.inspect message
  end
end
