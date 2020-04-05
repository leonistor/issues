defmodule Issues.CLI do
  @moduledoc """
  Handle command line parsing and dispatch arguments.
  """

  @default_count 4

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, returns :help

  Otherwise is github user name, project name and
  optionally number of entries to format.

  Returns {user, project, count} or :help
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help]
    )
    |> elem(1)
    |> args_to_internal()
  end

  def args_to_internal([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal([user, project]) do
    {user, project, @default_count}
  end

  def args_to_internal(_) do
    :help
  end
end
