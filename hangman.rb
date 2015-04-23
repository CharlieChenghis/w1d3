class Hangman


  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2

  end

  def play
    @word_length = @player1.pick_secret_word
    @player2.receive_secret_length(@word_length)
    @display = "_" * @word_length


    until win?
      guessed_letter = @player2.guess

      guess_response = @player1.check_guess(guessed_letter)
      update_display(guess_response, guessed_letter)

    end



  end

  def win?
    !@display.split('').include?('_')
  end

  def update_display(guess_response, guessed_letter)
    if guess_response.size == 0
      return
    else
      guess_response.each do |i|
        @display[i] = guessed_letter
      end
    end

    puts @display
  end




end


class HumanPlayer

  def pick_secret_word
    puts "How long is the secret word: "
    Integer(gets.chomp)
  end

  def receive_secret_length(secret_length)
    puts "the secret word is #{secret_length} letters long"
    @secret_length=secret_length
  end

  def guess
    puts "Pick a Letter: "
    gets.chomp
  end

  def check_guess(guessed_letter)
    puts "Other player guessed: #{guessed_letter}"
    puts "Is the #{guessed_letter} in your word? Y/N"
    yes_no = gets.chomp.upcase

    letter_indices = []

    until yes_no == "N"
      puts "Enter the index (starting from 0) where guessed letter appears: "
      letter_indices << Integer(gets.chomp)

      puts "Is there another letter? "
      yes_no = gets.chomp.upcase
    end
    letter_indices
  end

  def handle_guess_response
  end


end


class ComputerPlayer
  def initialize
    @past_guesses = []
    initiate_dictionary
  end

  def initiate_dictionary
    @dictionary = []
    File.foreach("dictionary.txt") do |line|
      @dictionary << line.strip
    end
    @mutable_dictionary = @dictionary.dup
  end

  def pick_secret_word
    @secret_word = @dictionary.sample
    @secret_word.length
  end

  def receive_secret_length(secret_length)

    @secret_length = secret_length
    update_dictionary_by_length
  end

  def guess
    computer_guess = best_guess
    @past_guesses << computer_guess
    puts "past_guessses are #{@past_guesses}"

    update_dictionary_by_letter(computer_guess)

    puts computer_guess
    computer_guess
  end

  def best_guess
    letter_hash = {}
    @mutable_dictionary.each do |word|
      word.split('').each do |letter|
        if letter_hash.has_key?(letter)
          letter_hash[letter] +=1
        else
          letter_hash[letter] = 1
        end
      end
    end
    # puts letter_hash
    guess_order = letter_hash.sort_by{|k,v| v}.reverse
    # p guess_order
    best_letter = ''

    guess_order.each do |k,v|
      if @past_guesses.include? k
        next
      else
        best_letter = k
        break
      end
    end
    best_letter
  end

  def update_dictionary_by_letter(computer_guess)
    if @secret_word.include?(computer_guess)

      @mutable_dictionary.select! do |word|
        word.include?(computer_guess)
      end
    else
      @mutable_dictionary.select! do |word|
        !word.include?(computer_guess)
      end
    end
    # p @mutable_dictionary
  end

  def update_dictionary_by_length

    @mutable_dictionary.select! do |word|
      word.length == @secret_length
    end
  end

  def check_guess(guessed_letter)
    letter_indices=[]
    @secret_word.split('').each_with_index do |o, i|
      letter_indices << i if o == guessed_letter
    end
    letter_indices
  end

  def handle_guess_response
  end
end

tester1 = ComputerPlayer.new
# # p tester.guess
tester2 = HumanPlayer.new

# tester1.update_dictionary_by_letter('x')


hangman = Hangman.new(tester1, tester1)
hangman.play
