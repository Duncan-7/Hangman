require "yaml"

class Answer
  attr_reader :answer
  def initialize
    @answer = find_answer
  end

  def find_answer
  loop
    x = File.readlines("5desk.txt").sample.downcase.gsub(/[^a-z]/, "")
    if 4 < x.length && x.length < 13
      return x.downcase
    end
  end
end

class Game
  attr_accessor :answer, :display_array, :display, :test_array, :strikes, :guessed
  
  def initialize(answer)
    @answer = answer.answer
    @test_array = @answer.split("")
    @display_array = Array.new(@answer.length, "_")
    @display = update_display
    @strikes = 6
    @guessed = []
  end

  def check_letter(letter)
    strikes_down = true
    test_array.each_with_index do |x,i|
      if x == letter
        display_array[i] = letter
        strikes_down = false
      end
    end
    if strikes_down 
      self.strikes -= 1
      puts "Wrong! Try again"
    else
      puts "Well done! We're getting close"
    end
  end

  def guess
    puts "Choose a letter:"
    guess = gets.chomp.downcase
    if guess == "save"
      save_game
      puts "See you later!"
      exit
    elsif !guess.match(/^[a-z]$/)
      puts "Invalid entry! Try again"
      self.guess
    elsif guessed.include?(guess)
      puts "We already tried that! Pick again"
      self.guess
    else
    guessed << guess
    return guess
    end
  end
  
  def update_display
    @display = display_array.join(" ")
  end

  def game
    new_game
    instructions
    puts
    
    until gameover?
    puts display
    puts
    puts "Letters guessed so far:"
    puts guessed.join(" ")
    puts
    puts "You have #{@strikes} strikes left!"
    puts
    x = guess
    check_letter(x)
    puts
    update_display
    end
  end

  def new_game
    puts "Would you like to start a new game (n), or load save data (l)?"
    response = gets.chomp.downcase
    if response == "n"
      return
    elsif response == "l"
      load_game
    else
      puts "Invalid entry! Please try again"
      new_game
    end
  end

  def gameover?
    if strikes == 0
      puts "You lose! Better luck next time"
      puts
      puts "The answer was #{answer}"
      true
    elsif display_array == test_array
      puts "You win! Congratulations!"
      true
    else
      false
    end
  end

  def instructions
    puts
    puts "Welcome to Hangman!"
    puts
    puts "Keep guessing letters you think are in the word, if you're right we'll put them in, if you're wrong you'll lose a strike! Guess all the letters before you lose all 5 strikes or suffer a fate exactly as bad as death!"
    puts
    puts "Type 'save' any time to save your game for later."
  end

  def save_game
    save_data = YAML::dump(self)
    save_file = File.open("savegame.yml", "w")
    save_file.write(save_data)
    save_file.close
  end

  def load_game
    if File.exists?("savegame.yml")
      load_file = File.open("savegame.yml", "r")
      load_data = load_file.read
      x = YAML::load(load_data)
      @answer = x.answer
      @test_array = x.test_array
      @display_array = x.display_array
      @display = x.display
      @strikes = x.strikes
      @guessed = x.guessed
    else
      puts "No save data present! Let's start a new game."
      puts
    end
  end
end

answer = Answer.new
game = Game.new(answer)
# game.check_letter("t")
# game.update_display
# p game.test_array
# game.game
p answer.answer
p game.answer
p game.test_array
p game.display_array
