defmodule RealtimeServer.RedisListener do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(_) do
    IO.puts("🔥 STARTING REDIS LISTENER")

    {:ok, conn} =
      Redix.PubSub.start_link("redis://localhost:6379/0")

    IO.puts("🔥 SUBSCRIBING TO user:*")

    # ✅ Pattern subscription
    {:ok, _ref} = Redix.PubSub.psubscribe(conn, ["user:*"])

    {:ok, %{conn: conn}}
  end

  # ✅ Important: match :pmessage now
  def handle_info(
        {:redix_pubsub, _conn, _ref, :pmessage,
         %{channel: channel, payload: payload}},
        state
      ) do
    IO.inspect({channel, payload}, label: "FROM REDIS")

    RealtimeServerWeb.Endpoint.broadcast(
      channel,
      "new_message",
      Jason.decode!(payload)
    )

    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}
end