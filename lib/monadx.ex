defmodule Monadx do
  defmacro __using__(_opts) do
    quote do
      defmacro monad(do: body) do
        case body do
          {__block__, [], exprs} ->
            __block__([ Monadx.reduce_monad(__MODULE__, exprs, []) ])
        end
      end

      def bind({:just, x}, f), do: f.(x)
      def bind(:nothing, _), do: :nothing
      def return(x), do: {:just, x}

      defoverridable [bind: 2]
      defoverridable [return: 1]
    end
  end

  @type monad :: any
  @callback bind(monad, (any -> monad)) :: monad
  @callback return(any) :: monad

  require IEx
  def reduce_monad(module, [expr|rest], acc) do
    case expr do
      {:<-, ctx, [{xsym, ctx, _}, m]} ->
        {:bind, [context: Elixir, import: module],
          [ m,
            {:fn, [], [{:->, [], [
              [{xsym, [], Elixir}],
              __block__( reduce_monad(module, rest, acc) )
            ]}]}]}
      {:let, _ctx, [{:=, _, _}=assgn]} ->
        reduce_monad(module, rest, [assgn|acc])
      {:return, _ctx, args} ->
        reduce_monad(module, rest, [{:return, [], args} | acc])
      # what about "bind with 0-arity fn?"
      _ -> raise "monad syntax error"
    end
  end
  def reduce_monad(_module, [], acc), do:
    Enum.reverse acc
end

defmodule MaybeM do
  use Monadx
end
