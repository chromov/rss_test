defmodule InnoTest.NetClient do
  def retrieve(url) do
    with {:ok, url} <- validate_url(url),
         {:ok, _response_body} = response <- send_request(url)
    do
      response
    else
      {:error, _reason} = error -> error
    end
  end

  defp send_request(url) do
    case HTTPoison.get(url, [], hackney: [pool: :first_pool]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status}} when status < 500 ->
        {:error, :no_retry}
      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, status}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp validate_url(url) do
    case URI.parse(url).host do
      nil -> {:error, :wrong_url}
      _ -> {:ok, url}
    end
  end
end
