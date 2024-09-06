defmodule AnthropicTest do
  use ExUnit.Case
  doctest Anthropic

  test "greets the world" do
    assert Anthropic.hello() == :world
  end
end
