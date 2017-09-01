defmodule HelloBitcoinTest do
  use ExUnit.Case
  doctest HelloBitcoin

  test "greets the world" do
    assert HelloBitcoin.hello() == :world
  end
end
