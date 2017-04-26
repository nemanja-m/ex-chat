defmodule ChatApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(ChatApp.Endpoint, []),
      worker(ChatApp.Cluster, []),
      worker(ChatApp.ClusterConsumer, [])
    ]

    opts = [strategy: :one_for_one, name: ChatApp.Supervisor]
    pid = Supervisor.start_link(children, opts)

    # Register self at master node.
    ChatApp.ClusterHandler.register_self()

    pid
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChatApp.Endpoint.config_change(changed, removed)
    :ok
  end
end
