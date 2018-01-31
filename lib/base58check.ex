defmodule Base58Check do
  def encode(data, version) do
    (version <> data <> checksum(data, version))
    |> Base58.encode()
  end

  defp checksum(data, version) do
    (version <> data)
    |> sha256
    |> sha256
    |> split
  end

  defp split(<<hash::bytes-size(4), _::bits>>), do: hash

  defp sha256(data), do: :crypto.hash(:sha256, data)
end
