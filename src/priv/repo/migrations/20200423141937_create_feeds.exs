defmodule InnoTest.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :title, :string
      add :description, :text
      add :url, :string, null: false
      add :raw_feed, :text
      add :items, :map
      add :items_limit, :integer, null: false, default: 10
      add :retries_count, :integer, null: false, default: 0
      add :error, :string
      add :is_active, :boolean, null: false, default: true
      add :last_sync_at, :naive_datetime
      add :deactivated_at, :naive_datetime

      timestamps()
    end

  end
end
