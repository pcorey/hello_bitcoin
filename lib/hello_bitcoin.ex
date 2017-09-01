defmodule HelloBitcoin do

  def bitcoin_rpc(method, params \\ []) do
    with url <- Application.get_env(:hello_bitcoin, :bitcoin_url),
         command <- %{jsonrpc: "1.0", method: method, params: params},
         {:ok, body} <- Poison.encode(command),
         {:ok, response} <- HTTPoison.post(url, body),
         {:ok, metadata} <- Poison.decode(response.body),
         %{"error" => nil, "result" => result} <- metadata do
      {:ok, result}
    else
      %{"error" => reason} -> {:error, reason}
      error -> error
    end
  end

  def getinfo, do: bitcoin_rpc("getinfo")

  def getblockhash(index), do: bitcoin_rpc("getblockhash", [index])

end
