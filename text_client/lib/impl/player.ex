defmodule TextClient.Impl.Player do
	@typep game :: Hangman.game
	@typep tally :: Hangman.tally
	@typep state :: {game, tally}

	@spec start() :: :ok
	def start() do
		game = Hangman.new_game
		tally = Hangman.tally(game)
		interact({game, tally})
	end

    def interact({_game, _tally = %{game_state: :won}}) do
    	IO.puts "Congratulations. you won!"
    end

    def interact({_game, tally = %{game_state: :lost}}) do
    	IO.puts "Sorry, you lost ... the word was #{tally.letters |> Enum.join}"
    end

	@spec interact(state) :: :ok
	def interact({game,tally}) do
		IO.puts feedback_for(tally) # feedback needs a tally
		IO.puts current_word(tally)	# display current word
		Hangman.make_move(game,get_guess()) # make move Hangman.make_move(game)
		|> interact()
	end

	def feedback_for(tally = %{game_state: :initializing}) do
		"Wellcome! I'm thinking of a #{tally.letters |>length} letter word"
	end

	def feedback_for(%{game_state: :good_guess}),   do: "Good guess!"
	def feedback_for(%{game_state: :bad_guess}),    do: "Sorry, that letter's not in the word"
	def feedback_for(%{game_state: :already_used}), do: "You aleady used that letter"

	def current_word(tally) do
		["Word so far: ", tally.letters |> Enum.join(" "),
		"   turns left: ", tally.turns_left |> to_string,
		"   used to far: ", tally.used |> Enum.join(",") ]
	end

	def get_guess() do
		IO.gets("Next letter:")
		|> String.trim()
		|> String.downcase()
	end
end