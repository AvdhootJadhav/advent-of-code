defmodule First do

  def main() do
    input = read()

    {first, second} = Enum.reduce(input, {[], []}, fn x, {first, second} ->
      data = String.split(x, "   ")
      first = [get_integer(to_string(hd(data))) | first]
      second = [get_integer(to_string(tl(data))) | second]

      {first, second}
    end)

    map = Enum.reduce(second, %{}, fn x, map ->
      case Map.fetch(map, x) do
        {:ok, value} ->
          map = Map.put(map, x, value + 1)
          map
        :error ->
          map = Map.put(map, x, 1)
          map
      end
    end)

    first = Enum.sort(first)
    second = Enum.sort(second)

    ans = Enum.zip(first, second)
    |> Enum.reduce([], fn {x,y}, diff ->
      diff = [abs(x-y) | diff]
      diff
    end)
    |> Enum.sum()

    IO.puts("result : #{ans}")

    scores = Enum.reduce(first, [], fn x, list ->
      value = if map[x] == nil do
        0
      else map[x]
      end
      list = [x*value | list]
      list
    end)

    result = Enum.sum(scores)

    IO.puts("Similarity score result : #{result}")

  end

  def read() do
    stream = File.stream!("../2019/demo.txt")
    inputList = Enum.to_list(Enum.map(stream, fn x -> String.trim(x) end))
    inputList
  end

  def get_integer(input) do
    case Integer.parse(input) do
      {number, ""} -> number
      _ -> nil
    end
  end

end

First.main()
