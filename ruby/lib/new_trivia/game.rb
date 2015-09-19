module UglyTrivia
  class Game
    def  initialize
      @questions = QuestionStack.new([:pop, :science, :sports, :rock], 50)
      @players = []
      @current_player = 0
      @penalty_box_behavior = StayPenaltyBox.new
    end

    def is_playable?
      how_many_players >= 2
    end

    def add(player_name)
      @players.push Player.new(player_name, 0 == how_many_players)
      puts "#{player_name} was added"
      puts "They are player number #{how_many_players}"
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{player.name} is the current player"
      puts "They have rolled a #{roll}"

      if player.in_penalty_box
        if roll % 2 != 0
          @penalty_box_behavior = QuitPenaltyBox.new
          puts "#{player.name} is getting out of the penalty box"
        else
          @penalty_box_behavior = StayPenaltyBox.new
          puts "#{player.name} is not getting out of the penalty box"
          return
        end
      end

      player.change_category(@questions, roll)
      puts "#{player.name}'s new location is #{player.category}"
      puts "The category is #{@questions.get_category(player.category)}"
      puts @questions.ask(player.category)
    end

    def was_correctly_answered
      winner = player.answer_correctly @penalty_box_behavior
      next_player
      return winner
    end

    def wrong_answer
      puts 'Question was incorrectly answered'
      puts "#{player.name} was sent to the penalty box"
      player.go_in_penalty_box
      next_player
      return true
    end

  private

    def player; @players[@current_player]; end

    def next_player; @current_player = (@current_player + 1) % how_many_players; end
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

    def ask(place); @categories[category(place)].shift; end

    def category(place); @categories.keys[place % @categories.size]; end

    def change_category(place, roll); (place + roll) % (@categories.size * 3); end

    def get_category(index); category_to_s(category(index)); end

    private
    def category_to_s(sym); sym.to_s.capitalize; end
  end

  class Player
    attr_reader :name, :in_penalty_box, :purse, :category

    def initialize(n, penalty)
      @name = n
      @in_penalty_box = penalty
      @purse = 0
      @category = 0
    end

    def answer_correctly(penalty_box_behavior)
      if in_penalty_box
        penalty_box_behavior.answer_correctly self
      else
        puts "Answer was corrent!!!!"
        increment_purse
        puts "#{name} now has #{purse} Gold Coins."
        win?
      end
    end

    def go_in_penalty_box; @in_penalty_box = true; end

    def increment_purse; @purse += 1; end

    def win?; !(@purse == 6); end

    def change_category(questions, roll); @category = questions.change_category(@category, roll); end
  end

  class StayPenaltyBox
    def answer_correctly(player)
      true
    end
  end

  class QuitPenaltyBox
    def answer_correctly(player)
      puts 'Answer was correct!!!!'
      player.increment_purse
      puts "#{player.name} now has #{player.purse} Gold Coins."
      player.win?
    end
  end
end
