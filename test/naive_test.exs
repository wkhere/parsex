defmodule Naive.Test do
  use ExUnit.Case
  import Naive

  test "bind" do
    assert \
      bind(zero, fn x -> return x end).("foo") == []
    assert \
      bind(item, fn x -> return x end).("123") == [{?1, "23"}]
    assert \
      bind(item,
        fn x -> bind(item,
          fn y -> return {x,y}
          end)
        end).("123") ==
      [{{?1,?2}, "3"}]
  end
end