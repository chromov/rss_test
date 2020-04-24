defmodule InnoTest.ParseWorker do
  use GenServer
  alias InnoTest.Feeds

  @feed_fields [:title, :description]
  @entry_fields [:id, :title, :url, :updated]

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok), do: {:ok, %{}}

  def handle_cast({:parse, %Feeds.Feed{} = feed}, state) do
    parse(feed)
    {:noreply, state}
  end

  defp parse(feed) do
    IO.puts "parse #{feed.url}"
    ElixirFeedParser.parse(feed.raw_feed) |> update_feed(feed)
  end

  defp update_feed({:ok, parsed}, feed) do
    items = parsed.entries |> Enum.take(feed.items_limit) |> Enum.map(fn(e) -> Map.take(e, @entry_fields) end)
    change = parsed |> Map.take(@feed_fields) |> Map.put(:items, items)
    Feeds.update_feed(feed, change)
  end
end
