defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  test ":help returned by parsing -h and --h" do
    assert parse_args(["-h", "loremipsum"]) == :help
    assert parse_args(["--help", "loremipsum"]) == :help
  end

  test "3 values for 3 given" do
    assert parse_args(["user", "project", "99"]) == {"user", "project", 99}
  end

  test "default count for 2 given" do
    assert parse_args(["user", "project"]) == {"user", "project", 4}
  end
end
