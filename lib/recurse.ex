defmodule Recurse do
  def triple([head|tail]) do
    [head*3 | triple(tail)]
  end

  def triple([]), do: []
end

IO.inspect Recurse.triple([1, 2, 3, 4, 5])
