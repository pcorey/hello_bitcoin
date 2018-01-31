defmodule PrivateKey do
  @n :binary.decode_unsigned(<<
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFF,
       0xFE,
       0xBA,
       0xAE,
       0xDC,
       0xE6,
       0xAF,
       0x48,
       0xA0,
       0x3B,
       0xBF,
       0xD2,
       0x5E,
       0x8C,
       0xD0,
       0x36,
       0x41,
       0x41
     >>)

  def generate do
    private_key = :crypto.strong_rand_bytes(32)

    case valid?(private_key) do
      true -> private_key
      false -> generate
    end
  end

  def to_public_key(private_key) do
    :crypto.generate_key(:ecdh, :crypto.ec_curve(:secp256k1), private_key)
    |> elem(0)
  end

  def to_public_hash(private_key) do
    private_key
    |> to_public_key
    |> hash(:sha256)
    |> hash(:ripemd160)
  end

  def to_public_address(private_key, version \\ <<0x00>>) do
    private_key
    |> to_public_hash
    |> Base58Check.encode(version)
  end

  def valid?(key) when is_binary(key) do
    key
    |> :binary.decode_unsigned()
    |> valid?
  end

  def valid?(key) when key > 1 and key < @n, do: true
  def valid?(_), do: false

  defp hash(data, algorithm), do: :crypto.hash(algorithm, data)
end
