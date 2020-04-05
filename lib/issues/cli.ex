defmodule Issues.CLI do
  @moduledoc """
  Handle command line parsing and dispatch arguments.
  """

  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  require Logger

  @default_count 4

  def main(argv) do
    Logger.info("started")

    argv
    |> parse_args()
    |> process()
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

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 -> i1["created_at"] >= i2["created_at"] end)
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end
end
