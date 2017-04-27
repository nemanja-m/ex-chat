defmodule ChatApp.ClusterHandler do

  alias ChatApp.{Config, Cluster}

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

  @doc """
  Notify rest of cluster that new node is registered. Also, returns
  list of current nodes in cluster to the new node ( sender ).
  """
  def update_cluster(node = %{"alias" => aliaz, "address" => _addr}, true) do
    update_sender(aliaz)
    notify_cluster(node)
  end
  def update_cluster(_params, false), do: nil

  @doc """
  Publish messages with specific type and payload to the
  receiver's exchange.
  """
  def publish_message(payload, type, receiver) do
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
    |> Enum.each(fn %{alias: receiver, address: _addr} ->
      publish_message(node, "REGISTER_NODE", receiver)
    end)
  end

  defp available_nodes_for(aliaz) do
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

end
