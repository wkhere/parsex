defmodule Monadx.Test do
  use ExUnit.Case

  test "maybe monad" do
    require Maybe

    v = Maybe.monad do: return 1
    assert v == {:just, 1}

    v = Maybe.monad do
      x <- {:just, 1}
      y <- {:just, 2}
      return {x,y}
    end
    assert v == {:just, {1,2}}

    v = Maybe.monad do
      x <- {:just, 1}
      _ <- :nothing
      return x
    end
    assert v == :nothing

    # same as above but return not needed
    v = Maybe.monad do
      _ <- {:just, 1}
      _ <- :nothing
    end
    assert v == :nothing

  end
end
