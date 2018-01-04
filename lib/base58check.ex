defmodule Base58Check do

  def encode(version, data) do
    version <> data <> checksum(version, data)
    |> Base58.encode
  end

  defp checksum(version, data) do
    version <> data
    |> sha256
    |> sha256
    |> split
  end

  defp split(<< hash :: bytes-size(4), _ :: bits >>), do: hash

  defp sha256(data), do: :crypto.hash(:sha256, data)

end
