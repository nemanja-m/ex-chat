defmodule ChatApp.ClusterHandler do

  alias ChatApp.{Config, Cluster}

  def exchange_name(aliaz) do
    "#{aliaz |> String.downcase}-exchange"
  end

  def update_cluster(node = %{"alias" => aliaz, "address" => _addr}, true) do
    # Send list of nodes in cluster to sender.
    update_sender(aliaz)

    # Notify rest of cluster that new node is registered.
    notify_cluster(node)
  end
  def update_cluster(_params, false), do: nil

  defp update_sender(sender) do
    options = publish_options(sender)

    message = %{
      type: "REGISTER_NODES",
      payload: available_nodes_for(sender)
    }

    Tackle.publish(Poison.encode!(message), options)
  end

  defp notify_cluster(node = %{"alias" => aliaz, "address" => _addr}) do
    available_nodes_for(aliaz)
    |> Enum.each(fn %{alias: receiver, address: _addr} ->

      message = %{
        type: "REGISTER_NODE",
        payload: node
      }

      options = publish_options(receiver)

      Tackle.publish(Poison.encode!(message), options)
    end)
  end

  defp available_nodes_for(aliaz) do
    Cluster.nodes
    |> Enum.reject(fn (node) -> node.alias == aliaz end)
    |> Enum.map(fn (node) -> node |> Map.from_struct |> Map.drop([:users]) end)
  end

  defp publish_options(aliaz) do
    %{
      url: Application.get_env(:chat_app, :rabbitmq_url),
      exchange: exchange_name(aliaz),
      routing_key: "cluster-event"
    }
  end

end
