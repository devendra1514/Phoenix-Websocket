defmodule RealtimeServerWeb.UserSocket do
  use Phoenix.Socket
  alias RealtimeServerWeb.Auth

  channel "user:*", RealtimeServerWeb.UserChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case validate_token_with_rails(token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}

      _ ->
        :error
    end
  end

  def connect(_, _, _), do: :error

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"

  defp validate_token_with_rails(token) do
    url = "http://localhost:5000/api/v1/profile"

    headers = [
      {"authorization", "Bearer #{token}"}
    ]

    case Req.get(url, headers: headers) do
      {:ok, %{status: 200, body: %{"data" => %{"id" => user_id}}}} ->
        {:ok, user_id}

      _ ->
        {:error, :invalid}
    end
  end
end