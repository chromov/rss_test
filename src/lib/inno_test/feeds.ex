defmodule InnoTest.Feeds do
  @moduledoc """
  The Feeds context.
  """

  import Ecto.Query, warn: false
  alias InnoTest.Repo

  alias InnoTest.Feeds.Feed

  @doc """
  Returns the list of feeds.

  ## Examples

      iex> list_feeds()
      [%Feed{}, ...]

  """
  def list_feeds do
    Repo.all(Feed)
  end

  @doc """
  Gets a single feed.

  Raises `Ecto.NoResultsError` if the Feed does not exist.

  ## Examples

      iex> get_feed!(123)
      %Feed{}

      iex> get_feed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feed!(id), do: Repo.get!(Feed, id)

  @doc """
  Gets next active feed to sync.

  ## Examples

      iex> get_next()
      %Feed{}

  """
  def get_next(opts \\ []) do
    interval = Application.get_env(:inno_test, :sync_interval)
    except_ids = Keyword.get(opts, :except, []) |> Enum.map(fn(%Feed{id: id}) -> id end)
    Feed
    |> filter_by_id(except_ids)
    |> where(is_active: true)
    |> where([f], is_nil(f.last_sync_at) or f.last_sync_at < ago(^interval, "minute"))
    |> limit(1)
    |> Repo.one
  end

  defp filter_by_id(query, []), do: query

  defp filter_by_id(query, ids), do: query |> where([f], f.id not in ^ids)

  @doc """
  Creates a feed.

  ## Examples

      iex> create_feed(%{field: value})
      {:ok, %Feed{}}

      iex> create_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feed(attrs \\ %{}) do
    %Feed{}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feed.

  ## Examples

      iex> update_feed(feed, %{field: new_value})
      {:ok, %Feed{}}

      iex> update_feed(feed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feed(%Feed{} = feed, attrs) do
    feed
    |> Feed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a raw_feed attribute on sync success.

  ## Examples

      iex> set_raw_feed(feed, body)
      {:ok, %Feed{}}

  """
  def set_raw_feed(%Feed{} = feed, body) do
    update_feed(feed, %{raw_feed: body, last_sync_at: NaiveDateTime.utc_now, retries_count: 0, error: nil})
  end

  @doc """
  Deactivates a feed by updating is_active field.

  ## Examples

      iex> deactivate_feed(feed)
      {:ok, %Feed{}}

  """
  def deactivate_feed(%Feed{} = feed) do
    update_feed(feed, %{deactivated_at: NaiveDateTime.utc_now, is_active: false})
  end

  @doc """
  Sets the error field or deactivates it if sync_retries is reached.

  ## Examples

      iex> set_error_or_deactivate_feed(feed, error)
      {:ok, %Feed{}}

  """
  def set_error_or_deactivate_feed(%Feed{retries_count: retries} = feed, error) do
    if retries >= Application.get_env(:inno_test, :sync_retries) do
      deactivate_feed(feed)
    else
      update_feed(feed, %{error: error, retries_count: retries + 1, last_sync_at: NaiveDateTime.utc_now})
    end
  end

  @doc """
  Deletes a feed.

  ## Examples

      iex> delete_feed(feed)
      {:ok, %Feed{}}

      iex> delete_feed(feed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feed(%Feed{} = feed) do
    Repo.delete(feed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feed changes.

  ## Examples

      iex> change_feed(feed)
      %Ecto.Changeset{data: %Feed{}}

  """
  def change_feed(%Feed{} = feed, attrs \\ %{}) do
    Feed.changeset(feed, attrs)
  end
end
