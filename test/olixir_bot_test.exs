defmodule OlixirBotTest do
  use ExUnit.Case
  doctest OlixirBot

  test "greets the world" do
    assert OlixirBot.hello() == :world
  end
end
