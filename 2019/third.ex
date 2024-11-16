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

    set = for x <- first, y <- second, do: get_distance(x, y)

    res = Enum.min(Enum.filter(set, fn x -> x != nil end))

    IO.puts("res : #{res}")
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

  def get_distance([x, y], [a, b]) do
    start1 = x
    end1 = y

    start2 = a
    end2 = b

    slope1 = calculate_slope(start1, end1)
    slope2 = calculate_slope(start2, end2)
    if slope1 != slope2 do
      point = calculate_intersection(start1, end1, start2, end2)

      case point do
        {0, 0} ->
          nil

        {p, q} ->
          if p >= elem(start1, 0) && p <= elem(end1, 0) && q >= elem(start1, 1) &&
               q <= elem(end1, 1) do
            p+q
          end

        _ ->
          nil
      end
    end
  end

  def calculate_intersection({x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}) do
    if y1 == y2 do
      if x3 >= min(x1, x2) && x3 <= max(x1, x2) do
        {x3, y1}
      end
    else
      if x1 == x2 do
        if x1 >= min(x3, x4) && x1 <= max(x3, x4) do
          {x1, y4}
        end
      end
    end
  end

  def calculate_slope({x1, y1}, {x2, y2}) do
    case x2 - x1 do
      0.0 -> false
      0 -> false
      dx -> abs((y2 - y1) / dx)
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
