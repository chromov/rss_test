defmodule InnoTest.ParseWorker do
  use GenServer
  alias InnoTest.Feeds

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def parse(feed), do: GenServer.cast(__MODULE__, {:parse, feed})

  def init(:ok), do: {:ok, %{}}

  def handle_cast({:parse, %Feeds.Feed{} = feed}, state) do
    feed.raw_feed |> InnoTest.RssParser.parse() |> update_feed(feed)
    {:noreply, state}
  end

  defp update_feed(parsed, feed) do
    Feeds.update_feed(feed, parsed)
  end
end
