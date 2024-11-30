defmodule Fourth do

  def main() do
    start = 240920
    finish = 789857

    count = count_valid_numbers(start, finish)

    IO.puts("Count of numbers : #{count}")
  end

  def count_valid_numbers(start, finish) do
    input_list = Enum.to_list(Enum.map(start..finish, fn x -> x end))

    final_list = input_list
    |> Enum.filter(fn x -> check_order(x) end)
    |> Enum.filter(fn x -> check_similarity(x) end)

    length(final_list)
  end

  def check_order(num) do
    list = Integer.digits(num)
    if Enum.sort(list) == list do
      true
    else false
    end
  end

  def check_similarity(num) do
    list = Integer.digits(num)

    {_, groups, group} = Enum.reduce(list, {-1, {}, {}}, fn x,{last,groups,group} ->
      if last == -1 do
        group = Tuple.append(group, x)
        {x, groups, group}
      else
        if last == x do
          group = Tuple.append(group, last)
          {x, groups, group}
        else
          groups = Tuple.append(groups, group)
          group = {x}
          {x, groups, group}
        end
      end
    end)

    groups = Tuple.append(groups,group)

    new_groups = Enum.filter(Tuple.to_list(groups), fn x -> tuple_size(x) > 1 end)

    cond_groups = Enum.filter(new_groups, fn x -> tuple_size(x) == 2 end)

    length(cond_groups) >= 1
  end

end

Fourth.main()
