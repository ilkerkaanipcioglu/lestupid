defmodule StandaloneTest do
  use ExUnit.Case, async: true

  test "basic assertion works" do
    assert 1 + 1 == 2
  end
  
  test "string operations work" do
    assert String.upcase("hello") == "HELLO"
  end
end
