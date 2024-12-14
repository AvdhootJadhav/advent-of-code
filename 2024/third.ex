defmodule Third do
  def main() do
    input = read()

    values = Enum.map(input, fn x->
      filtered = Regex.scan(~r/mul\([0-9]{1,3},[0-9]{1,3}\)|do\(\)|don't\(\)/, x)
      Enum.map(filtered, fn [y] -> y end)
    end)

    values = Enum.map(values, fn x ->
      {_, data} = Enum.reduce(x, {true, []}, fn x,{take,data}->
        case x do
          "do()" ->
            {true, data}
          "don't()" ->
            {false, data}
          _ ->
            if take do
              data = [x|data]
              {take, data}
            else
              {take, data}
            end
        end
      end)
      data
    end)

    formatted_input = values
    |> Enum.map(fn x->
      Enum.map(x, fn y->
        String.replace(y, "mul(", "")
        |> String.replace(")", "")
        |> String.split(",")
        |> Enum.map(fn x -> get_integer(x) end)
      end)
    end)

    result = Enum.reduce(formatted_input, 0, fn x,sum->
      sum = Enum.reduce(x, sum, fn [a,b],c->
        c = c + a*b
        c
      end)
      sum
    end)

    IO.puts("Result : #{result}")

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

Third.main()
