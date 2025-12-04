# Run command: elixir solution.exs
#
# I actually sort of enjoyed this one. Elixir was a pleasant surprise for me
# The way the piping works is beautiful. And the pattern matching like in haskell is very cool.
# And comprehension with generators are also nice. Did a brute force for part one
# and then part 2 gave me a reality check that I need to try harder...
# I will still keep my part 1 brute force cuz it's still instant.

import Enum

defmodule Solution do
  def indexed(e), do: zip(to_list(0..length(e)), e)

  def solve_row(a) do
    vals = indexed(a)
    max(for({i, x} <- vals, {j, y} <- vals, j > i, do: Integer.parse("#{x}#{y}") |> elem(0)))
  end

  def parse_row([]), do: []
  def parse_row([h | r]), do: [Integer.parse(h) |> elem(0) | parse_row(r)]

  def solve_1(f) do
    sum(
      for l <- String.split(elem(File.read(f), 1), "\n"),
          String.length(l) != 0,
          do: solve_row(parse_row(String.graphemes(l)))
    )
  end

  def solve_2_row(digits) do
    n = length(digits)

    digits
    |> indexed()
    |> reduce([], fn {pos, digit}, stack ->
      rest_count = n - pos

      stack
      |> delete_smaller(digit, rest_count)
      |> maybe_push(digit)
    end)
    |> reverse()
    |> join("")
    |> String.to_integer()
  end

  def delete_smaller(stack, digit, rest_count) do
    case stack do
      [last | rest] when last < digit ->
        sz = length(stack)
        quota = 12 - sz + 1

        if rest_count >= quota do
          delete_smaller(rest, digit, rest_count)
        else
          stack
        end

      _ ->
        stack
    end
  end

  def maybe_push(stack, digit) do
    if length(stack) < 12 do
      [digit | stack]
    else
      stack
    end
  end

  def solve_2(f) do
    sum(
      for l <- String.split(elem(File.read(f), 1), "\n"),
          String.length(l) != 0,
          do: solve_2_row(parse_row(String.graphemes(l)))
    )
  end
end

IO.inspect(Solution.solve_1("example.txt"))
IO.inspect(Solution.solve_2("example.txt"))
IO.inspect(Solution.solve_1("input.txt"))
IO.inspect(Solution.solve_2("input.txt"))
