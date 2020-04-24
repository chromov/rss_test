defmodule InnoTest.Feeds.Item do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}

  embedded_schema do
    field :title
    field :url
    field :updated, :naive_datetime
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:id, :title, :url, :updated])
    |> validate_required([:id, :title, :url, :updated])
  end
end
