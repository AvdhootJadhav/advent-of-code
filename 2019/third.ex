defmodule Third do

  defmodule Point do
    defstruct x: 0, y: 0
  end

  defmodule Line do
    defstruct point1: Point, point2: Point
  end

  def main() do
    input = read()
    parent = self()

    pids =
      Enum.map(input, fn x ->
        pid =
          spawn(fn ->
            trace_wires(x, parent)
            # send(self(), {:done, result})
          end)

        IO.puts("Process started at pid : #{inspect(pid)}")
        pid
      end)

    data =
      Enum.map(pids, fn _pids ->
        receive do
          {:done, msg} -> msg
        end
      end)

    first = hd(data)
    second = hd(tl(data))

    IO.puts("First : #{inspect(first)}")
    IO.puts("Second : #{inspect(second)}")

    for x <- first do
      for y <- second do
        check_intersection(x, y)
      end
    end
  end

  def trace_wires(directions, id) do
    list = Enum.to_list(String.split(to_string(directions), ","))

    data =
      Enum.reduce(list, [], fn x, acc ->
        direction = String.at(x, 0)
        slice = String.slice(x, 1..String.length(x))
        step = get_integer(slice)

        start =
          case acc do
            [] -> {0, 0}
            [head | _] -> hd(head)
          end

        x = elem(start, 0)
        y = elem(start, 1)

        trace = [{x, y}]
        new_coord = find_coord(x, y, direction, step)

        trace = [new_coord | trace]

        [trace | acc]
      end)

    send(id, {:done, data})
  end

  def check_intersection(l1, l2) do
    start1 = List.first(l1)
    end1 = List.last(l1)

    start2 = List.first(l2)
    end2 = List.last(l2)

    slope1 = if elem(end1, 0)-elem(start1, 0) == 0 do
      false
    else true
    end

    slope2 = if elem(end2, 0)-elem(start2, 0) == 0 do
      false
    else true
    end

    if slope1 && slope2 do
      IO.puts("Line 1 : #{inspect(start1)} #{inspect(end1)}")
      IO.puts("Line 2 : #{inspect(start2)} #{inspect(end2)}")
    end
  end

  def find_coord(x, y, direction, step) do
    case direction do
      "R" ->
        x = x + step
        {x, y}

      "D" ->
        y = y - step
        {x, y}

      "U" ->
        y = y + step
        {x, y}

      "L" ->
        x = x - step
        {x, y}
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
