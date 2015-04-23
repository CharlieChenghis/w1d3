
class Mastermind
  attr_accessor :board, :guess


  def initialize
    @board = Array.new(4)
    @right_color_right_index = 0
    @right_color_wrong_index = 0

  end


  def play
    random_colors
    p @board
    10.times do

      puts "Please guess first color: "
      f = gets.chomp

      puts "Please guess second color: "
      s = gets.chomp

      puts "Please guess third color: "
      t = gets.chomp

      puts "Please guess fourth color: "
      fo = gets.chomp

      @guess = [f, s, t, fo]
      p @guess

      if win?
        puts "Congrats, you won!"
        return
      else
        check_match
      end
    end
    if !win?
      puts "sorry, you lose!"
    end

  end

  def random_colors
    colors = %w(R G B Y O P)

    @board = [colors[rand(6)], colors[rand(6)], colors[rand(6)], colors[rand(6)]]
  end

  def check_match
    @right_color_right_index = 0
    @right_color_wrong_index = 0
    check_exact_matches
    check_near_matches
    display
  end

  def check_exact_matches
    @board.each_with_index do |b,i|
      @guess.each_with_index do |g,j|
        if b == g && i == j
          @right_color_right_index += 1
          @guess[j] = nil
        end
      end
    end
  end

  def check_near_matches
    @board.each_with_index do |b,i|
      @guess.each_with_index do |g,j|
        if b == g && i != j
          @right_color_wrong_index += 1
          @guess[j] = nil
        end
      end
    end
  end

  def win?
    @board == @guess
  end

  def display
    puts "you guessed #{@right_color_right_index} in the right color and position
     and #{@right_color_wrong_index} in the right color but wrong position"
  end
end



ac = Mastermind.new

ac.play
