defmodule ChatApp.ClusterTest do
  use ExUnit.Case, async: true

  alias ChatApp.{Cluster, Node, User}

  @node %{"alias" => "Mars", "address" => "localhost"}

  setup do
    Cluster.clear
  end

  test ".nodes" do
    Cluster.register_node @node

    node = %Node{alias: @node["alias"], address: @node["address"], users: %{}}

    assert Cluster.nodes == [ node ]
  end

  test ".register_node" do
    assert :ok = Cluster.register_node @node
    assert :node_exists = Cluster.register_node @node
    assert Enum.count(Cluster.nodes) == 1
  end

  test ".unregister_node" do
    :ok = Cluster.register_node @node

    Cluster.unregister_node @node["alias"]
    assert Enum.count(Cluster.nodes) == 0
  end

  test ".add_user" do
    Cluster.register_node @node

    assert :ok = Cluster.add_user @node["alias"], %User{}

    [node] = Cluster.nodes

    assert Enum.count(node.users) == 1
    assert node.users == %{42 => "John"}

    # Node doesn't exists
    assert :node_missing = Cluster.add_user "Neptune", %User{}
  end

  test ".remove_user" do
    Cluster.register_node @node

    :ok = Cluster.add_user @node["alias"], %User{}

    [node] = Cluster.nodes
    assert node.users == %{42 => "John"}

    Cluster.remove_user @node["alias"], 42

    [node] = Cluster.nodes
    assert node.users == %{}
  end

  test ".clear" do
    Cluster.register_node @node
    Cluster.register_node %{"alias" => "Neptune", "address" => "localhost:4000"}

    assert Enum.count(Cluster.nodes) == 2

    Cluster.clear

    assert Enum.count(Cluster.nodes) == 0
  end

end
