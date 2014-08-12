defmodule Parsex.Combinators do
  alias Parsex.Parser
  import Parser
  
  @type parser(a) :: parser(a)

  @spec item :: parser(char)
  def item do
    fn
      "" -> []
      <<c::utf8, rest::binary>> -> [{c, rest}]
    end
  end

  @spec seq(parser(any), parser(any)) :: parser(any)
  def seq(p, q) do
    m do
      x <- p
      y <- q
      return {x,y}
    end
  end

  @spec sat((char -> boolean)) :: parser(char)
  def sat(pred) do
    m do
      x <- item
      if pred.(x), do: return(x), else: zero
    end
  end
  
  @spec char(char) :: parser(char)
  def char(c), do:
    sat &(c == &1)

  @spec digit :: parser(char)
  def digit, do:
    sat &(&1 in ?0..?9)

  @spec lower :: parser(char)
  def lower, do:
    sat &(&1 in ?a..?z)

  @spec upper :: parser(char)
  def upper, do:
    sat &(&1 in ?A..?Z)

  @spec letter :: parser(char)
  def letter, do:
    plus(lower, upper)

  @spec alphanum :: parser(char)
  def alphanum, do:
    plus(letter, digit)

  @spec word :: parser(String.t)
  def word do
    nonempty_word = m do
      x <- letter
      xs <- word
      return <<x, xs::binary>>
    end
    plus(nonempty_word, return "")
  end

end
