defmodule Monadx.Test do
  use ExUnit.Case

  test "raw monad processing" do
    import Monadx

    ast = reduce_monad(Foo, quote do: (return 1))
    assert match? [{{:., [], [Foo, :return]}, [], [1]}], ast

    ast = reduce_monad(Foo, quote do
      x <- p
      return x
    end)
    assert(
      [{{:., [], [Foo, :bind]}, [],
        [{:p, [], _},
        {:fn, [],
          [{:->, [],
            [[{:x, [], _}],
            {:__block__, [],
              [{{:., [], [Foo, :return]}, [], [{:x, [], _}]}]}]}]}]}]
      |> match? ast)

    # todo: more
  end


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

    # bug: this is not working because `a` is bound *inside* fn x ..
    #    v = Maybe.monad do
    #      let a = 1
    #      x <- {:just, a}
    #      return x
    #    end
    #    assert v == {:just, 1}

    # other dark corners:
    # * if let is before any bind, the assignment leaks to the calling scope
    # * no support for bind/return/let nested in syntax constructs
    #   - needs rethinking how reduce_monad should work
  end
end
