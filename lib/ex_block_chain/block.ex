defmodule ExBlockchain.Block do

  defstruct timestamp: ~N[1990-01-01 00:00:00],
    transactions: [],
    previous_hash: "",
    hash: "",
    nonce: 0

  def new(transactions) do
    hash(%ExBlockchain.Block{
          timestamp: NaiveDateTime.utc_now(),
          transactions: transactions
    })
  end

  def hash(block) do
    hash_string = :crypto.hash(
      :sha256,
      Poison.encode!(block.transactions)
      <> block.previous_hash
      <> to_string(block.nonce)
    )

    Map.put(block, :hash, hash_string)
  end

  def mine(block, difficulty) do
    now = block.hash
    |> Base2.encode2()
    |> String.slice(0..difficulty - 1)

    target = String.duplicate("0", difficulty)

    if now != target do
      block
      |> Map.put(:nonce, block.nonce + 1)
      |> hash()
      |> mine(difficulty)
    else
      block
    end
  end
end
