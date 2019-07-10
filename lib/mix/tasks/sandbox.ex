defmodule Mix.Tasks.Sandbox do
  use Mix.Task
  alias ExBlockchain.Chain
  alias ExBlockchain.Block

  @shortdoc "Run something"
  def run(_) do
    Chain.new()
    |> Chain.add_block(Block.new(1, NaiveDateTime.utc_now(), %{ amount: 10 }))
    |> Chain.add_block(Block.new(2, NaiveDateTime.utc_now(), %{ amount: 100 }))
    |> Chain.valid?()
    |> IO.inspect()
  end
end
