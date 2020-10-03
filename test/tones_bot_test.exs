defmodule TonesBotTest do
  use ExUnit.Case
  doctest TonesBot

  test "greets the world" do
    assert TonesBot.hello() == :world
  end
end
