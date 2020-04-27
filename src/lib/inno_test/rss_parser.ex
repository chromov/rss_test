defmodule InnoTest.RssParser do
  @feed_fields [:title, :description]
  @entry_fields [:id, :title, :url, :updated]

  def parse(xml, items_limit \\ 10) do
    ElixirFeedParser.parse(xml) |> extract(items_limit)
  end

  def extract({:ok, parsed}, items_limit) do
    parsed
    |> Map.take(@feed_fields)
    |> Map.put(:items,
      parsed.entries
      |> Enum.take(items_limit)
      |> Enum.map(fn(e) ->
        Map.take(e, @entry_fields)
      end)
    )
  end

  def extract(_, _items_limit), do: %{error: "Parsing error"}
end
