defmodule InnoTest.FetchWorker do
  use GenServer
  alias InnoTest.Feeds

  @refresh_interval 5_000

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    schedule()
    {:ok, %{}}
  end

  def handle_info(:work, state) do
    Feeds.get_next() |> fetch()
    schedule()
    {:noreply, state}
  end

  defp fetch(%Feeds.Feed{} = feed) do
    IO.puts "fetch #{feed.url}"
    InnoTest.NetClient.retrieve(feed.url) |> update_feed(feed) |> send_to_parser()
  end

  defp fetch(_), do: false

  defp update_feed({:ok, body}, feed), do: Feeds.set_raw_feed(feed, body)

  defp update_feed({:error, :no_retry}, feed), do: Feeds.deactivate_feed(feed)

  defp update_feed({:error, reason}, feed), do: Feeds.set_error_or_deactivate_feed(feed, Atom.to_string(reason))

  defp send_to_parser({:ok, %Feeds.Feed{error: nil, is_active: true} = feed}),
    do: GenServer.cast(InnoTest.ParseWorker, {:parse, feed})

  defp send_to_parser(_), do: false

  defp schedule(), do: Process.send_after(self(), :work, @refresh_interval)
end
