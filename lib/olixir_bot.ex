defmodule OlixirBot do
  @moduledoc """
  Documentation for OlixirBot.
  """
  use Coxir

  def handle_event({:MESSAGE_CREATE, message}, state) do
    case message.content do
      "i!reload" ->
	if is_owner(message[:author]) do
	  IEx.Helpers.recompile()
	  Message.reply(message, "Done")
	else
	  Message.reply(message, "Error: not bot owner")
	end
      "i!emojitext" ->
	Message.reply(message, "Error: No arguments provided")
      "i!emojitext " <> text ->
	Message.reply(message,
	  to_string(List.flatten(Enum.map(String.graphemes(text), &to_emoji/1))))
      "i!test" ->
	Message.reply(message, "tested")
      _ ->
	:ignore
    end

    {:ok, state}
  end

  def handle_event(_event, state) do
    {:ok, state}
  end

  defp is_owner(author) do
    if author[:username] == "wildbartty" and author[:discriminator] == "5710" do
      true
    else
      false
    end
  end

  defp to_emoji(char) do
    alphabet =
      ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    lower = :string.lowercase(char)
    cond do
      Enum.member?(alphabet, lower) ->
	[":regional_indicator_", lower,":"]
      char == " " -> "  "
      true ->
	char
    end
  end
end

defmodule Example do
  use Application
  use Supervisor

  def start(_type, _args) do
    children = [
      worker(OlixirBot, [])
    ]
    options = [
      strategy: :one_for_one,
      name: __MODULE__
    ]
    Supervisor.start_link(children, options)
  end
end

defmodule ChatterbotDaemon do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], [{:name, __MODULE__}])
  end

  def init(args) do
    port = Port.open({:spawn, "python chatbot.py"}, [:binary])
    {:ok, port}
  end

  def handle_call(:get_port, _from, state) do
    {:reply, state, state}
  end

end
