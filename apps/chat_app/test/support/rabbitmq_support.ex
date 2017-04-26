defmodule RabbitmqSupport do

  def purge_queues(queues) do
    {:ok, connection} = AMQP.Connection.open("amqp://localhost")
    {:ok, channel} = AMQP.Channel.open(connection)

    queues
    |> Enum.each(fn queue_name ->
      AMQP.Queue.purge(channel, queue_name)
    end)

    AMQP.Connection.close(connection)
  end

end
