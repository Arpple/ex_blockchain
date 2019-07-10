defmodule ExBlockchain.Transaction do

  defstruct from: "",
    to: "",
    amount: ""

  def new(from, to, amount) do
    %ExBlockchain.Transaction{from: from, to: to, amount: amount}
  end
end
