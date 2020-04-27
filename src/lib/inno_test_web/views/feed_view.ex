defmodule InnoTestWeb.FeedView do
  use InnoTestWeb, :view
  alias InnoTest.Feeds.Feed

  def title_or_url(%Feed{title: nil, url: url}), do: url
  def title_or_url(%Feed{title: title}), do: title

  def show_as_json(val), do: Jason.encode!(val, pretty: true)
end
