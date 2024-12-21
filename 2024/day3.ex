defmodule Third do
  def main() do
    input =
      read()
      |> Enum.join("")

    values = Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/, input)

    {_, data} =
      Enum.reduce(values, {true, []}, fn [x], {take, data} ->
        case x do
          "do()" ->
            {true, data}

          "don't()" ->
            {false, data}

          _ ->
            if take do
              data = [x | data]
              {take, data}
            else
              {take, data}
            end
        end
      end)

    formatted_input =
      data
      |> Enum.map(fn x ->
        String.replace(x, "mul(", "")
        |> String.replace(")", "")
        |> String.split(",")
        |> Enum.map(fn x -> get_integer(x) end)
      end)

    result =
      Enum.reduce(formatted_input, 0, fn [a, b], sum ->
        sum = sum + a * b
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
