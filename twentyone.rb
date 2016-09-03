class Player
  def initialize
    @hand = []
    @total = 0
    @score = 0
  end

  attr_accessor :hand, :score
  attr_writer :total

  def busted?
    total > Game.game_score
  end

  def cards
    cards = []
    hand.each_index do |index|
      cards << hand[index].card
    end
    cards
  end

  def hit(deck)
    puts "#{self.class} hits!"
    hand << deck.deal
  end

  def total
    @total = 0
    cards.each do |card|
      @total += Deck.card_values[card[1]]
    end
    return @total -= 10 if ace? && (@total > Game.game_score - 4)
    @total
  end

  private

  def ace?
    cards.each do |card|
      return true if card[1] == "Ace"
    end
    false
  end
end

class Dealer < Player
  def stay
    return true if total > Game.game_score - 1
  end
end

class Deck
  attr_accessor :cards

  @@card_values = { 2 => 2, 3 => 3, 4 => 4,
                    5 => 5, 6 => 6, 7 => 7,
                    8 => 8, 9 => 9, 10 => 10,
                    "Jack" => 10, "Queen" => 10,
                    "King" => 10, "Ace" => 11 }

  def self.card_values
    @@card_values
  end

  def initialize
    create_and_shuffle
  end

  def deal
    cards.shift
  end

  private

  def create_and_shuffle
    @cards = []
    52.times do
      @cards << Card.new
    end
    @cards.shuffle!
  end
end

class Card
  attr_reader :card

  @@cards = [["S", 2], ["D", 2], ["C", 2], ["H", 2],
             ["S", 3], ["D", 3], ["C", 3], ["H", 3],
             ["S", 4], ["D", 4], ["C", 4], ["H", 4],
             ["S", 5], ["D", 5], ["C", 5], ["H", 5],
             ["S", 6], ["D", 6], ["C", 6], ["H", 6],
             ["S", 7], ["D", 7], ["C", 7], ["H", 7],
             ["S", 8], ["D", 8], ["C", 8], ["H", 8],
             ["S", 9], ["D", 9], ["C", 9], ["H", 9],
             ["S", 10], ["D", 10], ["C", 10], ["H", 10],
             ["S", "Jack"], ["D", "Jack"], ["C", "Jack"],
             ["H", "Jack"], ["S", "Queen"], ["D", "Queen"],
             ["C", "Queen"], ["H", "Queen"], ["S", "King"],
             ["D", "King"], ["C", "King"], ["H", "King"],
             ["S", "Ace"], ["D", "Ace"], ["C", "Ace"],
             ["H", "Ace"]]

  def initialize
    @card = @@cards.pop
  end
end

class Game
  attr_accessor :deck, :human, :dealer

  WINNING_SCORE = 5

  def self.prompt_for_game_score
    game_score = nil
    loop do
      puts "What would you like to play to?"
      game_score = gets.chomp.to_i
      break if game_score > 20
      puts "Please enter a number greater than 20"
    end
    game_score
  end

  @@game_score = prompt_for_game_score

  def self.game_score
    @@game_score
  end

  def initialize
    @deck = Deck.new
    @human = Player.new
    @dealer = Dealer.new
  end

  def start
    loop do
      reset
      display_series_score
      break if series_winner?
      deal_cards
      show_initial_cards
      player_turn
      dealer_turn
      show_result
      break unless play_again?
    end
    puts "Thank you for playing. Goodbye!"
  end

  private

  def play_again?
    decision = nil
    loop do
      puts "Play again? (y/n)"
      decision = gets.chomp.upcase
      break if %w(Y N).include?(decision)
    end
    decision == "Y"
  end

  def clear
    system 'clear'
  end

  def reset
    clear
    human.hand = []
    dealer.hand = []
    human.total = 0
    dealer.total = 0
  end

  def deal_cards
    2.times do
      human.hand << deck.cards.shift
      dealer.hand << deck.cards.shift
    end
  end

  def player_turn
    loop do
      puts
      decision = nil
      loop do
        prompt "Would you like to hit or stay?"
        decision = gets.chomp.capitalize
        break if %w(H S Hit Stay).include?(decision)
      end
      break if decision.start_with?("S")
      human.hit(deck)
      break if human.busted?
      display_player_cards
    end
  end

  def dealer_turn
    loop do
      break if human.busted?
      display_dealer_cards
      break if dealer.stay
      dealer.hit(deck) if dealer.total < Game.game_score
      break if dealer.busted?
    end
  end

  def show_initial_cards
    puts "Dealer has #{dealer.cards[0]} and ?"
    puts "Player has #{human.cards[0]} and #{human.cards[1]}" \
         " for a total of #{human.total}"
  end

  def display_player_cards
    puts "Player's cards are #{human.cards} for a total of #{human.total}"
  end

  def display_dealer_cards
    puts "Dealer's cards are #{dealer.cards} for a total of #{dealer.total}"
  end

  def display_participants_cards
    puts
    display_player_cards
    display_dealer_cards
  end

  def display_busted_player
    display_player_cards
    puts "Player busted"
    puts "Dealer wins!"
    dealer.score += 1
  end

  def display_busted_dealer
    display_dealer_cards
    puts "Dealer busted"
    puts "Player wins!"
    human.score += 1
  end

  def declare_player_winner
    display_participants_cards
    puts "Dealer busted" if dealer.busted?
    puts "Player wins!"
    human.score += 1
  end

  def declare_dealer_winner
    display_participants_cards
    puts "Dealer wins!"
    dealer.score += 1
  end

  def player_won_after_round?
    human.total > dealer.total
  end

  def dealer_won_after_round?
    dealer.total > human.total
  end

  def display_series_score
    puts "Player: #{human.score} Dealer: #{dealer.score}"
  end

  def player_wins_series?
    human.score == 5
  end

  def dealer_wins_series?
    dealer.score == 5
  end

  def someone_won_the_series?
    human.score == 5 || dealer.score == 5
  end

  def series_winner?
    if player_wins_series?
      puts "Player wins series"
    elsif dealer_wins_series?
      puts "Dealer wins series"
    end
    someone_won_the_series?
  end

  def show_result
    if human.busted?
      display_busted_player
    elsif dealer.busted?
      display_busted_dealer
    elsif player_won_after_round?
      declare_player_winner
    elsif dealer_won_after_round?
      declare_dealer_winner
    else
      display_participants_cards
      puts "It's a tie"
    end
  end

  def prompt(message)
    puts "=> #{message}"
  end
end

Game.new.start
