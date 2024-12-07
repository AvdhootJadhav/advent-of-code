defmodule Second do
  def main() do
    input =
      Enum.map(read(), fn x ->
        Enum.map(String.split(to_string(x), " "), fn y -> get_integer(y) end)
      end)
      |> Enum.filter(fn x -> Enum.sort(x) == x || Enum.reverse(Enum.sort(x)) == x end)

    {_, c} = Enum.reduce(input, {0,0}, fn x,{last,count}->
      {l, c} = Enum.reduce_while(tl(x), {hd(x), 0}, fn y,{last, count} ->
        cond do
          abs(y-last) >= 1 && abs(y-last) <= 3 ->
            count = count + 1
            {:cont, {y,count}}
          true -> {:halt, {last, count}}
        end
      end)
      if c === length(x)-1 do
        count = count+1
        last = l
        {last, count}
      else {last, count}
      end
    end)

    IO.puts("count : #{c}")
  end

  def read() do
    stream = File.stream!("../demo.txt")
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

Second.main()
