require Logger

defmodule Echo do
  use Application

  def start(_type, _args) do
    Logger.info("[echo]#start")
    { :ok, _ } = :ranch.start_listener(:tcp_echo, 1,
      :ranch_tcp, [port: 5555], EchoProtocol, [])
    EchoSup.start_link
  end

  def stop(_state) do
    :ok
  end
end
