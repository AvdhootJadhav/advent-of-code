defmodule Third do
  defmodule Metadata do
    defstruct visited: false, wire: 0
  end

  def main() do
    input = read()

    {_, _, exists, _} =
      Enum.reduce(input, {%{}, {0, 0}, [], true}, fn x, {acc, bcc, alr, first} ->
        process_puzzle(x, {acc, bcc, alr, first})
      end)

    IO.puts("Potential candidates : #{inspect(exists)}")

    distance = Enum.min(Enum.map(exists, fn x -> abs(elem(x, 0)) + abs(elem(x, 1)) end))

    IO.puts("Closest distance : #{distance}")
  end

  def process_puzzle(x, {acc, bcc, alr, first}) do
    processedInput = Enum.to_list(String.split(to_string(x), ","))

    {data, _, alr, first} =
      Enum.reduce(processedInput, {acc, bcc, alr, first}, fn y, {acc, bcc, alr, first} ->
        handle_coordinates(y, {acc, bcc, alr, first})
      end)

    {data, {0, 0}, alr, first}
  end

  def handle_coordinates(x, {acc, pos, alr, first}) do
    step = get_integer(String.slice(x, 1..String.length(x)))
    direction = String.at(x, 0)

    {last, new_acc, alr, _} =
      Enum.reduce(1..step, {pos, acc, alr, first}, fn _x, {bcc, acc, alr, first} ->
        start = bcc

        new_coord = calculate_coordinate(start, direction)

        case Map.fetch(acc, new_coord) do
          {:ok, value} ->
            current_wire = get_wire(first)
            wire = value.wire

            if wire != current_wire do
              {new_coord, acc, [new_coord | alr], first}
            else
              {new_coord, acc, alr, first}
            end

          :error ->
            new_acc =
              Map.put(acc, new_coord, %Metadata{
                visited: true,
                wire:
                  if first do
                    1
                  else
                    2
                  end
              })

            {new_coord, new_acc, alr, first}
        end
      end)

    {new_acc, last, alr, false}
  end

  def get_wire(first) do
    if first do
      1
    else
      2
    end
  end

  def calculate_coordinate({x, y}, direction) do
    case direction do
      "R" ->
        {x + 1, y}

      "L" ->
        {x - 1, y}

      "D" ->
        {x, y - 1}

      "U" ->
        {x, y + 1}
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
