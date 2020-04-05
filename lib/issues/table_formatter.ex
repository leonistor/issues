defmodule Issues.TableFormatter do
  def print_table_for_columns(rows, headers) do
    rows
    |> Scribe.print(
      data: headers,
      style: Scribe.Style.GithubMarkdown,
      width: 90
    )
  end
end
