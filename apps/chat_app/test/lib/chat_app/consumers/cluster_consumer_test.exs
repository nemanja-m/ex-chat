defmodule ChatApp.ClusterConsumerTest do
  use ExUnit.Case

  alias ChatApp.{Config, Cluster, Node}

  @options %{
    url: Application.get_env(:chat_app, :rabbitmq_url),
    exchange: Config.master_exchange,
    routing_key: "cluster-event"
  }

  defmodule NeptuneConsumer do use Tackle.Consumer,
      url: Application.get_env(:chat_app, :rabbitmq_url),
      exchange: "neptune-exchange",
      routing_key: "cluster-event",
      service: "Neptune"

    def handle_message(message) do
      case Poison.decode!(message) do
        %{"type" => "REGISTER_NODES", "payload" => nodes} ->
          Poison.encode!(nodes) |> MessageTrace.save("cluster-consumer")

        _ -> nil
      end
    end
  end

  defmodule JupiterConsumer do
    use Tackle.Consumer,
      url: Application.get_env(:chat_app, :rabbitmq_url),
      exchange: "jupiter-exchange",
      routing_key: "cluster-event",
      service: "Jupiter"

    def handle_message(message) do
      case Poison.decode!(message) do
        %{"type" => "REGISTER_NODE", "payload" => node} ->
          Poison.encode!(node) |> MessageTrace.save("cluster-consumer-node")

        %{"type" => "UNREGISTER_NODE", "payload" => %{"alias" => aliaz}} ->
          aliaz |> MessageTrace.save("cluster-consumer-unregister")

        _ -> nil
      end
    end
  end

  def this_as_node do
    %{alias: aliaz, address: address} = Config.this()

    %Node{alias: aliaz, address: address}
  end

  def purge_queues(aliases) do
    queues =
      aliases
      |> Enum.map(fn aliaz ->
        [
          "#{aliaz}.cluster-event.delay.10",
          "#{aliaz}.cluster-event.dead",
          "#{aliaz}.cluster-event"
        ]
      end)
      |> Enum.concat

    RabbitmqSupport.purge_queues(queues)
  end

  setup_all do
    {:ok, npid} = NeptuneConsumer.start_link
    {:ok, ypid} = JupiterConsumer.start_link

    purge_queues([Config.alias, "Neptune", "Jupiter"])

    MessageTrace.clear("cluster-consumer")
    MessageTrace.clear("cluster-consumer-node")
    MessageTrace.clear("cluster-consumer-unregister")

    on_exit fn ->
      Process.exit npid, :kill
      Process.exit ypid, :kill
    end
  end

  test "handle_message" do
    # Put some nodes in cluster before test.
    :ok = Cluster.register_node(%{"alias" => "Jupiter", "address" => "milkyway"})

    message = %{
      type: "REGISTER_NODE",
      payload: %{"alias" => "Neptune", "address" => "localhost"}
    }

    Tackle.publish(Poison.encode!(message), @options)

    :timer.sleep(2 * 1000)

    refute MessageTrace.content("cluster-consumer") |> String.contains?("Neptune")
    assert MessageTrace.content("cluster-consumer") |> String.contains?("Jupiter")
    assert MessageTrace.content("cluster-consumer-node") |> String.contains?("Neptune")

    # Unregister node.

    message = %{
      type: "UNREGISTER_NODE",
      payload: %{"alias" => "Neptune"}
    }

    Tackle.publish(Poison.encode!(message), @options)

    :timer.sleep(2 * 1000)

    assert Cluster.nodes == [%Node{alias: "Jupiter", address: "milkyway", users: %{}}, this_as_node()]
    assert MessageTrace.content("cluster-consumer-unregister") |> String.contains?("Neptune")
  end

end
