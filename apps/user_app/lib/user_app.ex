defmodule UserApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(UserApp.Repo, []),
      # Start the endpoint when the application starts
      supervisor(UserApp.Endpoint, []),
      # Start the RabbitMQ consumer
      supervisor(UserApp.UserEventsConsumer, [])
    ]

    opts = [strategy: :one_for_one, name: UserApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    UserApp.Endpoint.config_change(changed, removed)
    :ok
  end
end
