defmodule Player do
  defstruct name: " ", symbol: " "
end

defmodule TicTacToe do

  defp print_board(board) do
    IO.puts( Enum.at(Enum.at(board, 0), 0) <> " | " <> Enum.at(Enum.at(board, 0), 1) <> " | " <> Enum.at(Enum.at(board, 0), 2) )
    IO.puts( "--|---|--" )
    IO.puts( Enum.at(Enum.at(board, 1), 0) <> " | " <> Enum.at(Enum.at(board, 1), 1) <> " | " <> Enum.at(Enum.at(board, 1), 2) )
    IO.puts( "--|---|--" )
    IO.puts( Enum.at(Enum.at(board, 2), 0) <> " | " <> Enum.at(Enum.at(board, 2), 1) <> " | " <> Enum.at(Enum.at(board, 2), 2) )
  end

  defp check_free_space(board) do
    Enum.member?(Enum.at(board, 0), " ") or Enum.member?(Enum.at(board, 1), " ") or Enum.member?(Enum.at(board, 2), " ")
  end

  defp player_move(board, player) do
    if(check_free_space(board)) do
      row = get_valid_input("Input row for #{player.symbol}: ", [1, 2, 3]) - 1
      column = get_valid_input("Input column for #{player.symbol}: ", [1, 2, 3]) - 1

      if(Enum.at(Enum.at(board, row), column) == " ") do
        make_move(board, row, column, player.symbol)
      else
        IO.puts("Spot already taken.")
        player_move(board, player)
      end
    else
      board
    end

  end

  defp get_valid_input(prompt, valid_values) do
    input = IO.gets("#{prompt}") |> String.trim() |> String.to_integer()
    if input in valid_values do
      input
    else
      IO.puts("Invalid input, try again.")
      get_valid_input(prompt, valid_values)
    end
  end

  def make_move(board, row, column, symbol) do
    List.replace_at(board, row, List.replace_at(Enum.at(board, row), column, symbol))
  end

  defp check_winner(board) do
    first_row = Enum.at(board, 0)
    second_row = Enum.at(board, 1)
    third_row = Enum.at(board, 2)

    game_lines = [
      Enum.at(board, 0),
      Enum.at(board, 1),
      Enum.at(board, 2),
      [Enum.at(first_row, 0), Enum.at(second_row, 0), Enum.at(third_row, 0)],
      [Enum.at(first_row, 1), Enum.at(second_row, 1), Enum.at(third_row, 1)],
      [Enum.at(first_row, 2), Enum.at(second_row, 2), Enum.at(third_row, 2)],
      [Enum.at(first_row, 0), Enum.at(second_row, 1), Enum.at(third_row, 2)],
      [Enum.at(first_row, 2), Enum.at(second_row, 1), Enum.at(third_row, 0)]
    ]

    Enum.any?(game_lines, fn list ->
      if(Enum.at(list, 1) != " " and Enum.at(list, 1) == Enum.at(list, 0) and Enum.at(list, 1) == Enum.at(list, 2)) do
        true
      else
        false
      end
    end)

  end

  defp check_tie(board) do
    !Enum.member?(Enum.at(board, 0), " ") and !Enum.member?(Enum.at(board, 1), " ") and !Enum.member?(Enum.at(board, 2), " ")
  end

  defp game_loop(board, player1, player2) do
    print_board(board)

    case check_game_state(board) do
      :win ->
        IO.puts("There is a winner!")
      :tie ->
        IO.puts("It's a tie!")
      :continue ->
        board = player_move(board, player1)
        game_loop(board, player2, player1)
    end

  end

  defp check_game_state(board) do
    if check_winner(board) do
      :win
    else
      if(check_tie(board)) do
        :tie
      else
        :continue
      end
    end
  end

  def start_game do
    IO.puts("\tWelcome to Tic Tac Toe.\nInput coordinates to put your symbol. \nExample: coordinate (1, 1) is the top left corner.\n\tHave fun!\n")
    board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
    player1 = %Player{name: "Player 1", symbol: "X"}
    player2 = %Player{name: "Player 2", symbol: "O"}
    game_loop(board, player1, player2)
  end

end

TicTacToe.start_game()
