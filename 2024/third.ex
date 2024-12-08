defmodule Third do
  def main() do
    input = read()

    values = Enum.map(input, fn x->
      filtered = Regex.scan(~r/mul[(][0-9]{1,3},[0-9]{1,3}[)]/, x)
      Enum.map(filtered, fn [y] -> y end)
    end)
    |> Enum.map(fn x->
      Enum.map(x, fn y->
        String.replace(y, "mul(", "")
        |> String.replace(")", "")
        |> String.split(",")
        |> Enum.map(fn x -> get_integer(x) end)
      end)
    end)

    result = Enum.reduce(values, 0, fn x,sum->
      sum = Enum.reduce(x, sum, fn [a,b],sum->
        sum = sum + a*b
        sum
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
