defmodule ChatApp.Config do

  def master_node_url do
    Application.get_env(:chat_app, :master_node)[:url]
  end

  def address do
    host = Application.get_env(:chat_app, ChatApp.Endpoint)[:url][:host]
    port = Application.get_env(:chat_app, ChatApp.Endpoint)[:http][:port]

    "#{host}:#{port}"
  end

  def alias do
    Application.get_env(:chat_app, :alias)
  end

  def is_master? do
    Application.get_env(:chat_app, :master) == "true"
  end

  def host_info do
    %{ host: %{ address: address(), alias: alias() } }
  end

  def this do
    host_info()[:host]
  end

  def master_node_alias do
    Application.get_env(:chat_app, :master_node)[:alias]
  end

  def master_exchange do
    "#{master_node_alias() |> String.downcase}-exchange"
  end

end
