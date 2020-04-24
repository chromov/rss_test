defmodule InnoTest.NetClient do

  def retrieve(url) do
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

end
