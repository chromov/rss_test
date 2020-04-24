defmodule InnoTest.Feeds.Feed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "feeds" do
    field :title, :string
    field :description, :string
    field :raw_feed, :string
    field :items_limit, :integer
    field :url, :string
    field :retries_count, :integer
    field :error, :string
    field :is_active, :boolean
    field :last_sync_at, :naive_datetime
    field :deactivated_at, :naive_datetime

    embeds_many :items, InnoTest.Feeds.Item, on_replace: :delete

    timestamps()
  end


  @doc false
  def changeset(feed, attrs) do
    feed
    |> cast(attrs, [:title, :description, :raw_feed, :items_limit, :url, :retries_count, :error, :is_active, :last_sync_at, :deactivated_at])
    |> cast_embed(:items)
    |> validate_required([:url])
  end
end
