defmodule Third do
  defmodule Steps do
    defstruct first: 0, second: 0
  end

  defmodule Metadata do
    defstruct visited: false, wire: 0, steps: %Steps{}
  end

  def main() do
    input = read()

    {map, _, exists, _, _} =
      Enum.reduce(input, {%{}, {0, 0}, [], true, 0}, fn x, {acc, bcc, alr, first, steps} ->
        process_puzzle(x, {acc, bcc, alr, first, steps})
      end)

    min_steps =
      Enum.reduce(exists, 10_000_000, fn x, mini ->
        case Map.fetch(map, x) do
          {:ok, value} ->
            sum = value.steps.first + value.steps.second

            if sum < mini do
              sum
            else
              mini
            end
        end
      end)

    IO.puts("Minimum steps : #{min_steps}")

    distance = Enum.min(Enum.map(exists, fn x -> abs(elem(x, 0)) + abs(elem(x, 1)) end))

    IO.puts("Closest distance : #{distance}")
  end

  def process_puzzle(x, {acc, bcc, alr, first, steps}) do
    processedInput = Enum.to_list(String.split(to_string(x), ","))

    {data, _, alr, _, _} =
      Enum.reduce(processedInput, {acc, bcc, alr, first, steps}, fn y,
                                                                    {acc, bcc, alr, first, steps} ->
        handle_coordinates(y, {acc, bcc, alr, first, steps})
      end)

    {data, {0, 0}, alr, false, 0}
  end

  def handle_coordinates(x, {acc, pos, alr, first, steps}) do
    step = get_integer(String.slice(x, 1..String.length(x)))
    direction = String.at(x, 0)

    {last, new_acc, alr, first, steps} =
      Enum.reduce(1..step, {pos, acc, alr, first, steps}, fn _x, {bcc, acc, alr, first, steps} ->
        start = bcc

        new_coord = calculate_coordinate(start, direction)
        steps = steps + 1

        case Map.fetch(acc, new_coord) do
          {:ok, value} ->
            current_wire = get_wire(first)
            wire = value.wire

            if wire != current_wire do
              acc =
                Map.put(acc, new_coord, %Metadata{
                  visited: true,
                  wire: value.wire,
                  steps: %Steps{
                    first: value.steps.first,
                    second: steps
                  }
                })

              {new_coord, acc, [new_coord | alr], first, steps}
            else
              {new_coord, acc, alr, first, steps}
            end

          :error ->
            new_acc =
              Map.put(acc, new_coord, %Metadata{
                visited: true,
                steps: %Steps{first: steps, second: 0},
                wire:
                  if first do
                    1
                  else
                    2
                  end
              })

            {new_coord, new_acc, alr, first, steps}
        end
      end)

    {new_acc, last, alr, first, steps}
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
