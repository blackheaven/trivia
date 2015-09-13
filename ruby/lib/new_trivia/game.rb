module UglyTrivia
  class Game
    def  initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, 0)

      @questions = { :pop => [], :science => [], :sports => [], :rock => []}

      @current_player = 0
      @is_getting_out_of_penalty_box = false

      50.times do |i|
        @questions[:pop].push "Pop Question #{i}"
        @questions[:science].push "Science Question #{i}"
        @questions[:sports].push "Sports Question #{i}"
        @questions[:rock].push "Rock Question #{i}"
      end
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players.push player_name
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{@players[@current_player]} is the current player"
      puts "They have rolled a #{roll}"

      if @in_penalty_box[@current_player]
        if roll % 2 != 0
          @is_getting_out_of_penalty_box = true

          puts "#{@players[@current_player]} is getting out of the penalty box"
          change_category(@current_player, roll)
          ask_question
        else
          puts "#{@players[@current_player]} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          end

      else

        change_category(@current_player, roll)
        ask_question
      end
    end

  private

    def ask_question
      puts @questions[current_category].shift
    end

    def current_category
      [:pop, :science, :sports, :rock][@places[@current_player] % 4]
    end

    def change_category(player, roll)
      @places[@current_player] = @places[@current_player] + roll
      @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

      puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category.to_s.capitalize}"
    end

  public

    def was_correctly_answered
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win()
          @current_player += 1
          @current_player = 0 if @current_player == @players.length

          winner
        else
          @current_player += 1
          @current_player = 0 if @current_player == @players.length
          true
        end



      else

        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        @current_player += 1
        @current_player = 0 if @current_player == @players.length

        return winner
      end
    end

    def wrong_answer
  		puts 'Question was incorrectly answered'
  		puts "#{@players[@current_player]} was sent to the penalty box"
  		@in_penalty_box[@current_player] = true

      @current_player += 1
      @current_player = 0 if @current_player == @players.length
  		return true
    end

  private

    def did_player_win
      !(@purses[@current_player] == 6)
    end
  end
end
