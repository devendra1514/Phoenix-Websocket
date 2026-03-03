defmodule RealtimeServerWeb.UserChannel do
  use Phoenix.Channel

  @impl true
  def join("user:" <> user_id, _params, socket) do
    if Integer.to_string(socket.assigns.user_id) == user_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info({:redis_message, message}, socket) do
    push(socket, "new_event", Jason.decode!(message))
    {:noreply, socket}
  end
end