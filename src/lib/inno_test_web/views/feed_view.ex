defmodule InnoTestWeb.FeedView do
  use InnoTestWeb, :view
  alias InnoTest.Feeds.Feed

  def title_or_url(%Feed{title: nil, url: url} = feed), do: url
  def title_or_url(%Feed{title: title} = feed), do: title
end
