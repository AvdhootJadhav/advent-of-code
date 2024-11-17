defmodule Third do

  def main() do
    input = read()

    _ = Enum.reduce(input, {%{}, {0,0}, []}, fn x, {acc, bcc, alr} -> process_puzzle(x, {acc, bcc, alr}) end)
  end

  def process_puzzle(x, {acc, bcc, alr}) do
    processedInput = Enum.to_list(String.split(to_string(x), ","))

    {data, last, alr} = Enum.reduce(processedInput, {acc, bcc, alr}, fn y, {acc, bcc, alr} -> handle_coordinates(y, {acc, bcc, alr}) end)

    IO.puts("Already exists : #{inspect(alr)}")
    # IO.puts("Map : #{inspect(data)}")

    {data, last, alr}
  end

  def handle_coordinates(x, {acc, pos, alr}) do
    step = get_integer(String.slice(x, 1..String.length(x)))
    direction = String.at(x, 0)

    {last, new_acc, alr} = Enum.reduce(1..step, {pos, acc, alr}, fn _x, {bcc, acc, alr} ->
      start = bcc

      # IO.puts("Start value : #{inspect(start)}")
      new_coord = calculate_coordinate(start, direction)

      case Map.fetch(acc, new_coord) do
        {:ok, _value} ->
          # IO.puts("Already exists : #{inspect(start)} value : #{value}")
          {new_coord, acc, [new_coord | alr]}
        :error ->
          new_acc = Map.put(acc, new_coord, true)
          {new_coord, new_acc, alr}
      end
    end)
    # IO.puts("Last value : #{inspect(last)}")
    # IO.puts("Map value : #{new_acc[last]}")
    {new_acc, last, alr}
  end

  def calculate_coordinate({x,y}, direction) do
    case direction do
      "R" ->
        x = x + 1
        {x, y}
      "L" ->
        x = x - 1
        {x,y}
      "D" ->
        y = y - 1
        {x,y}
      "U" ->
        y = y + 1
        {x,y}
    end
  end

  def read() do
    stream = File.stream!("demo.txt")
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
