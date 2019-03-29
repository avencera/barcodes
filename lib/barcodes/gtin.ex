defmodule Barcodes.Gtin do
  @spec generate_all(String.t()) :: [%{uid: String.t(), upc: String.t(), check_digit: String.t()}]
  def generate_all(prefix) when is_binary(prefix) do
    prefix
    |> prefix_to_list()
    |> do_generate_all()
  end

  @spec generate_upc(String.t()) :: [String.t()]
  def generate_upc(prefix) when is_binary(prefix) do
    prefix
    |> generate_all()
    |> Enum.map(fn all -> Map.get(all, :upc) end)
  end

  defp do_generate_all(prefix) do
    prefix_string = Enum.join(prefix, "")

    prefix
    |> length()
    |> uids()
    |> Enum.map(fn uid -> {prefix_string <> uid, uid} end)
    |> Enum.map(fn {x, uid} -> {ExGtin.generate_gtin(x), uid} end)
    |> Enum.map(fn {upc, uid} -> %{upc: upc, uid: uid, check_digit: String.last(upc)} end)
  end

  defp prefix_to_list(prefix) do
    prefix
    |> String.split("")
    |> Enum.reject(fn x -> x == "" end)
    |> Enum.map(&String.to_integer/1)
  end

  defp uids(10), do: do_uids(9, 1)
  defp uids(9), do: do_uids(99, 2)
  defp uids(8), do: do_uids(999, 3)
  defp uids(7), do: do_uids(9999, 4)
  defp uids(6), do: do_uids(99999, 5)

  defp do_uids(end_number, padding) do
    0..end_number
    |> Enum.into([])
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.pad_leading(&1, padding, "0"))
  end
end
