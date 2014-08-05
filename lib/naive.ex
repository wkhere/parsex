defmodule Naive do
  
  # page 4, `result` is changed for `return`

  @type parser(a) :: (String.t -> [{a, String.t}])

  @spec return(any) :: parser(any)
  def return(v), do:
    fn inp -> [{v, inp}] end
  
  # page 5

  @spec zero() :: parser(any)
  def zero(), do:
    fn _input -> [] end

  @spec item() :: parser(char)
  def item() do
    fn 
      "" -> []
      <<x::utf8, xs::binary>> -> [{x, xs}]
    end
  end

  @spec bind(parser(any), (any -> parser(any))) :: parser(any)
  def bind(p, f) do
    fn inp ->
      (for {v,inp1} <- p.(inp), do: f.(v).(inp1)) |> List.flatten
    end
  end

  # page 6

  @spec seq(parser(any), parser(any)) :: parser(any)
  def seq(p, q) do
    bind(p, fn x ->
      bind(q, fn y ->
        return {x,y}
      end)
    end)
  end

  @spec sat((char -> boolean)) :: parser(char)
  def sat(pred) do
    bind(item, fn x ->
      if pred.(x), do: return(x), else: zero
    end)
  end

  @spec char(char) :: parser(char)
  def char(c), do:
    sat &(c == &1)

  # page 7

  @spec digit() :: parser(char)
  def digit(), do:
    sat &(&1 in ?0..?9)

  @spec lower() :: parser(char)
  def lower(), do:
    sat &(&1 in ?a..?z)

  @spec upper() :: parser(char)
  def upper(), do:
    sat &(&1 in ?A..?Z)

end
