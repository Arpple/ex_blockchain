defmodule Mix.Tasks.Sandbox do
  use Mix.Task
  alias ExBlockchain.Chain
  alias ExBlockchain.Transaction

  @shortdoc "Run something"
  def run(_) do
    chain = Chain.new(10)
    |> Chain.create_transaction(Transaction.new("address1", "address2", 100))
    |> Chain.create_transaction(Transaction.new("address2", "address1", 50))

    chain
    |> Chain.mine_pending_transactions("arpple-address")
    |> Chain.mine_pending_transactions("arpple-address")
    |> Chain.get_balance("arpple-address")
    |> IO.inspect()
  end
end
