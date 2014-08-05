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

  test "seq" do
    assert seq(item, item).("123") == [{ {?1,?2}, "3" }]
  end

  test "sat" do
    assert sat(fn _ -> false end).("foo") == []
    assert sat(&(?x == &1)).("xu") == [{?x, "u"}]
  end

  test "char" do
    assert char(?a).("foo") == []
    assert char(?a).("abc") == [{?a, "bc"}]
    assert seq(char(?a), char(?b)).("abc") == [{ {?a,?b}, "c"}]
  end

  test "digit" do
    assert digit.("foo") == []
    assert digit.("1x")  == [{?1, "x"}]
  end

  test "lower" do
    assert lower.("foo") == [{?f, "oo"}]
    assert lower.("Hi!") == []
  end

  test "upper" do
    assert upper.("foo") == []
    assert upper.("Hi!") == [{?H, "i!"}]
  end

end
