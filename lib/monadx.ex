defmodule Monadx do
  defmacro __using__(_opts) do
    quote location: :keep do
      @behaviour Monadx

      defmacro monad(do: body) do
        quote do: (unquote_splicing(Monadx.reduce_monad(__MODULE__, body)))
      end
    end
  end

  @type monad :: any
  @callback bind(monad, (any -> monad)) :: monad
  @callback return(any) :: monad


  # helpers

  def reduce_monad(module, body) do
    reduce_monad(module,
      case body do
        {:__block__, _, exprs} -> exprs
        expr -> [expr]
      end,
      [])
  end

  def reduce_monad(module, [expr|rest], acc) do
    case expr do
      {:<-, _ctx, [x, m]} ->
        bound = quote do
          unquote(module).bind(unquote(m), fn unquote(x) ->
            unquote_splicing( reduce_monad(module, rest, []) )
          end)
        end
        reduce_monad(module, [], [bound | acc])
      {:let, _ctx, [{:=, _, _}=assgn]} ->
        reduce_monad(module, rest, [assgn | acc])
      {:return, _ctx, args} ->
        ret = quote do: unquote(module).return(unquote_splicing(args))
        reduce_monad(module, rest, [ret | acc])
      # what about "bind with 0-arity fn?"
      _ -> raise "monad syntax error: #{inspect expr}"
    end
  end
  def reduce_monad(_module, [], acc), do:
    Enum.reverse acc
end


defmodule Maybe do
  use Monadx
  def bind({:just, x}, f), do: f.(x)
  def bind(:nothing, _), do: :nothing
  def return(x), do: {:just, x}
end
