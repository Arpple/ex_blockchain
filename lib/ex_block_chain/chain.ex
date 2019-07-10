defmodule ExBlockchain.Chain do
  defstruct blocks: [],
    difficulty: 10,
    pending_transactions: [],
    mining_reward: 100

  def new(difficulty) do
    block = ExBlockchain.Block.new([])
    %ExBlockchain.Chain{difficulty: difficulty, blocks: [block]}
  end

  def last_block(%{blocks: [head|_]}) do
    head
  end

  def mine_pending_transactions(chain, reward_address) do
    block = ExBlockchain.Block.new(chain.pending_transactions)
    |> ExBlockchain.Block.mine(chain.difficulty)

    chain
    |> Map.put(:blocks, [block|chain.blocks])
    |> Map.put(:pending_transactions, [
      ExBlockchain.Transaction.new(nil, reward_address, chain.mining_reward)
    ])
  end

  def create_transaction(chain, transaction)  do
    Map.put(chain, :pending_transactions, [transaction|chain.pending_transactions])
  end

  def get_balance(chain, address) do
    Enum.reduce(chain.blocks, 0, fn (block, acc) ->
      acc + sum_block(block, address)
    end)
  end

  defp sum_block(block, address) do
    Enum.reduce(block.transactions, 0, fn (%{from: from, to: to, amount: amount}, acc) ->
      case address do
        ^from -> acc - amount
        ^to -> acc + amount
        _ -> acc
      end
    end)
  end

  def valid?(chain) do
    blocks = chain.blocks

    blocks
    |> Enum.with_index()
    |> Enum.reduce(true, fn ({curr, index}, acc) ->
      index == length(blocks) - 1
      || (
        acc
        && curr.hash == ExBlockchain.Block.hash(curr).hash
        && curr.previous_hash == Enum.at(blocks, index + 1).hash
      )
    end)
  end
end
