defmodule Recurse do
  def map([head | tail], transformer) do
    [transformer.(head) | map(tail, transformer)]
  end

  def map([], _), do: []
end

double = fn x -> x * 2 end

IO.inspect(Recurse.map([1, 2, 3, 4, 5], double))
