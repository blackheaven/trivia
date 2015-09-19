module UglyTrivia
  class Game
    def  initialize
      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, 0)

      @questions = QuestionStack.new([:pop, :science, :sports, :rock], 50)

      @current_player = 0
      @is_getting_out_of_penalty_box = false
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players.push player_name
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      puts "#{player_name} was added"
      puts "They are player number #{how_many_players}"

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
      puts @questions.ask(current_category)
    end

    def current_category
      @places[@current_player]
    end

    def change_category(player, roll)
      @places[@current_player] = @questions.change_category(current_category, roll)

      puts "#{@players[@current_player]}'s new location is #{current_category}"
      puts "The category is #{@questions.get_category(current_category)}"
    end

  public

    def was_correctly_answered
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win
          next_player
          winner
        else
          next_player
          true
        end

      else

        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        next_player
        return winner
      end
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{@players[@current_player]} was sent to the penalty box"
      @in_penalty_box[@current_player] = true
        next_player
      return true
    end

  private

    def did_player_win
      !(@purses[@current_player] == 6)
    end

    def next_player
      @current_player = (@current_player + 1) % how_many_players
    end
  end

  class QuestionStack
    def initialize(categories, nb)
      @categories = {}
      categories.each do |c|
        @categories[c] = []
      end
      nb.times do |i|
        categories.each do |c|
          @categories[c].push "#{category_to_s(c)} Question #{i}"
        end
      end
    end

    def ask(place)
      @categories[category(place)].shift
    end

    def category(place)
      @categories.keys[place % @categories.size]
    end

    def change_category(place, roll)
      (place + roll) % (@categories.size * 3)
    end

    def get_category(index)
      category_to_s(category(index))
    end

    private
    def category_to_s(sym)
      sym.to_s.capitalize
    end
  end
end
