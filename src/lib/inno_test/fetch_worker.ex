defmodule InnoTest.FetchWorker do
  use GenServer
  alias InnoTest.Feeds

  @refresh_interval 5_000

  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  def init(:ok) do
    schedule()
    {:ok, []}
  end

  def handle_info(:work, state) do
    in_progress = state |> Enum.map(fn({_p, feed}) -> feed end)
    tasks = Feeds.get_next(except: in_progress) |> fetch() |> List.wrap()
    schedule()
    {:noreply, tasks ++ state}
  end

  def handle_info({:finished, feed, result}, state) do
    result |> update_feed(feed) |> send_to_parser()
    {:noreply, state}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    state = Enum.filter(state, fn({p, _f}) -> p != pid end)
    {:noreply, state}
  end

  defp fetch(%Feeds.Feed{} = feed) do
    IO.puts "fetch #{feed.url}"

    caller = self()
    {:ok, pid} = Task.start(fn() ->
      res = InnoTest.NetClient.retrieve(feed.url)
      send(caller, {:finished, feed, res})
    end)
    Process.monitor(pid)
    {pid, feed}
  end

  defp fetch(_), do: []

  defp update_feed({:ok, body}, feed), do: Feeds.set_raw_feed(feed, body)

  defp update_feed({:error, :no_retry}, feed), do: Feeds.deactivate_feed(feed)

  defp update_feed({:error, reason}, feed), do: Feeds.set_error_or_deactivate_feed(feed, Atom.to_string(reason))

  defp send_to_parser({:ok, %Feeds.Feed{error: nil, is_active: true} = feed}), do: InnoTest.ParseWorker.parse(feed)

  defp send_to_parser(_), do: false

  defp schedule(), do: Process.send_after(self(), :work, @refresh_interval)
end
