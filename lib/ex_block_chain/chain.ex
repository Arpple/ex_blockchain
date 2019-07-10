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

  def add_block(chain, block) do
    last = last_block(chain)

    new_block = block
    |> Map.put(:previous_hash, last.hash)
    |> ExBlockchain.Block.mine(chain.difficulty)

    Map.put(chain, :blocks, [new_block|chain.blocks])
  end

  def mine_pending_transaction(chain, reward_address) do
    block = ExBlockchain.new(chain.pending_transaction)
    |> ExBlockchain.Block.mine(chain.difficulty)

    chain
    |> Map.put(:blocks, [block|chain.blocks])
    |> Map.put(:pending_transactions, [%ExBlockchain.Transaction.new(nil, reward_address, chain.mining_reward)])
  end

  def create_transaction(chain, transaction)  do
    Map.put(chain, :pending_transaction, [transaction|chain.pending_transaction])
  end

  def get_balance(chain, address) do
    Enum.reduce(chain.blocks, 0, fn (block, acc) ->
      
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
