defmodule Mix.Tasks.Sandbox do
  use Mix.Task
  alias ExBlockchain.Chain
  alias ExBlockchain.Block

  @shortdoc "Run something"
  def run(_) do
    Chain.new(10)
    |> Chain.add_block(Block.new(%{ amount: 10 }))
    |> Chain.add_block(Block.new(%{ amount: 100 }))
    |> Chain.valid?()
    |> IO.inspect()
  end
end
