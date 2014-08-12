defmodule Parsex.Parser do
  use Monad

  @type t(a) :: (String.t -> [{a, String.t}])

  @spec bind(t(any), (any -> t(any))) :: t(any)
  def bind(p, f) do
    fn inp -> 
      (for {v,inp1} <- p.(inp), do: f.(v).(inp1)) |> Enum.concat
    end
  end

  @spec return(any) :: t(any)
  def return(v), do:
    fn inp -> [{v, inp}] end

  @spec zero :: t(any)
  def zero, do:
    fn _inp -> [] end

  @spec plus(t(any), t(any)) :: t(any)
  def plus(p, q), do:
    fn inp -> p.(inp) ++ q.(inp) end

end
