defmodule ChatApp.ConfigTest do
  use ExUnit.Case, async: true

  alias ChatApp.Config

  test ".alias" do
    assert Config.alias == "Mars"
  end

  test ".address" do
    assert Config.address == "localhost:4001"
  end

  test ".master_node_url" do
    assert Config.master_node_url == "http://localhost:3000/api"
  end

  test ".is_master?" do
    assert Config.is_master? == true
  end
end
