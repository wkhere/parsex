defmodule Monad.Test do
  use ExUnit.Case

  test "maybe monad" do
    # This is not really needed, as Monad.Maybe is test-covered
    # in the monad package. I leave it just for keeping my memory
    # aware of various use cases.
    alias Monad.Maybe
    require Maybe

    v = Maybe.m do: return 1
    assert v == {:just, 1}

    v = Maybe.m do
      x <- {:just, 1}
      y <- {:just, 2}
      return {x,y}
    end
    assert v == {:just, {1,2}}

    v = Maybe.m do
      x <- {:just, 1}
      _ <- :nothing
      return x
    end
    assert v == :nothing

    # same as above but return not needed
    v = Maybe.m do
      _ <- {:just, 1}
      :nothing
    end
    assert v == :nothing

    v = Maybe.m do
      let a = 1
      x <- {:just, a}
      return x
    end
    assert v == {:just, 1}

    v = Maybe.m do
      x <- {:just, 1}
      let a = 2
      y <- {:just, a}
      return [x,y]
    end
    assert v == {:just, [1,2]}
  end
end
