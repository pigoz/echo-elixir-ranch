require Logger

defmodule EchoProtocol do
  @behaviour :ranch_protocol
  @timeout 5000

  def start_link(ref, socket, transport, opts) do
    Logger.info("[echo] new client")
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    { :ok, pid }
  end

  def init(ref, socket, transport, _opts = []) do
    ok = :ranch.accept_ack(ref)
    loop(socket, transport)
  end

  defp loop(socket, transport) do
    case transport.recv(socket, 0, @timeout) do
      {:ok, data} ->
        transport.send(socket, data)
        loop(socket, transport)
      _ ->
        :ok = transport.close(socket)
    end
  end
end
