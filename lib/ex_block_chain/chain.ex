defmodule ExBlockchain.Chain do
  @difficulty 15

  def new() do
    [%ExBlockchain.Block{
        index: 0,
        timestamp: NaiveDateTime.utc_now(),
        data: %{ content: "Genesis" }
    }]
  end

  def last_block([head|_]) do
    head
  end

  def add_block(chain, block) do
    last = last_block(chain)

    new_block = block
    |> Map.put(:previous_hash, last.hash)
    |> ExBlockchain.Block.mine(@difficulty)

    [new_block|chain]
  end

  def valid?(chain) do
    chain
    |> Enum.with_index()
    |> Enum.reduce(true, fn ({curr, index}, acc) ->
      index == length(chain) - 1
      || (
        acc
        && curr.hash == ExBlockchain.Block.hash(curr).hash
        && curr.previous_hash == Enum.at(chain, index + 1).hash
      )
    end)
  end
end
