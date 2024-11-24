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

    {_, check} = Enum.reduce(list, {0, false}, fn x,{last,exist} ->
       if !exist do
        if last == x do
          {last, true}
        else {x, exist}
        end
       else
        {last, exist}
       end
    end)
    check
  end

end

Fourth.main()
