defmodule VanityAddress do

  def stream_private_keys(regex, version \\ <<0x00>>) do
    [fn -> generate_private_key(regex, version) end]
    |> Stream.cycle
    |> Task.async_stream(fn f -> f.() end)
    |> Stream.map(fn
      {:ok, thing} -> thing
      _ -> nil
    end)
    |> Stream.reject(&(&1 == nil))
  end

  def generate_private_key(regex, version \\ <<0x00>>) do
    private_key = PrivateKey.generate
    public_address = PrivateKey.to_public_address(private_key, version)
    case public_address =~ regex do
      true -> private_key
      false -> generate_private_key(regex, version)
    end
  end

end
