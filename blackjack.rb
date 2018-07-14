class Blackjack

  def initialize
    @deck_track = Array.new(13, 0)
    @player_hand = []
    @dealer_hand = []
  end

# --------------------------------------------------------------------

  def deal_card
    card = rand(1..13)
    
    loop do
      if(@deck_track[card-1] < 4)
        @deck_track[card-1] += 1
        break
      else
        card = rand(1..13)
      end
    end

    case card
      when 1
        return "A"
      when 11
        return "J"
      when 12
        return "Q"
      when 13
        return "K"
      else
        return card
    end
  end

# -------------------------------------------------------------------

  def get_card_total(is_dealer=false, limited=false)
    is_dealer ? cards = @dealer_hand : cards = @player_hand

    total = 0
    has_A = false;
    
    cards.each do |card|
      case card
        when "A"
          total += 1
          has_A = true if !has_A
        when "K"
          total += 10
        when "Q"
          total += 10
        when "J"
          total += 10
        else
          total += card
      end
    end
    
    total += 10 if has_A == true && total + 10 <= 21 && !limited
    return total
  end

# ---------------------------------------------------------------

  def display_cards_and_total(is_dealer=false)
    if is_dealer
      card_total = get_card_total(true)
      limited_total = get_card_total(true, true)
      hand_display = @dealer_hand[1..-1].unshift("?")
      hidden_card = @dealer_hand.slice(0)

      case hidden_card
        when "A"
          hidden = 11
        when "K"
          hidden = 10
        when "Q"
          hidden = 10
        when "J"
          hidden = 10
        else
          hidden = hidden_card
      end

      hidden_card == "A" && limited_total + 10 > 21 ? limited_total = card_total - 1 : limited_total = card_total - hidden
   
      puts "Dealer's Hand:" 
      puts "Cards: #{hand_display}"
      #puts "Real Total: #{card_total}"
      puts "Current Total: #{limited_total}\n\n"
    else
      card_total = get_card_total()
      puts "Player's Hand:"
      puts "Cards: #{@player_hand}"
      puts "Total: #{card_total}\n\n"
    end
  end

# ------------------------------------------------------------------------------------------------

  def get_user_input
    puts "Type 'h' to hit or 's' to stay"
    gets.chomp.strip
  end

# -------------------------------------------------------------------------------------------------

  def initial_round
    player_card_1 = deal_card
    player_card_2 = deal_card
    
    dealer_card_1 = deal_card
    dealer_card_2 = deal_card
    return [player_card_1, player_card_2], [dealer_card_1, dealer_card_2]
  end

# ------------------------------------------------------------------------------------------------

  def hit?(is_dealer=false)
    # dealer
    if is_dealer
      cards_total = get_card_total(true)
      dealer_stay = true

      if(cards_total < 17) # hit
        dealer_stay = false
        @dealer_hand.push(deal_card)
      end
      return dealer_stay
    end
    
    # player
    input = get_user_input
    player_stay = true

    if(input == "s")
      return player_stay
    elsif(input == "h") 
      player_stay = false
      @player_hand.push(deal_card)
      return player_stay
    else
      puts "Please enter a valid command"
      hit?()
    end
  end

# --------------------------------------------------------------------------------

  def play
    puts "Welcome to the Blackjack Table\n\n"
    @player_hand, @dealer_hand = initial_round
    display_cards_and_total()
    display_cards_and_total(true)

    player_card_total = get_card_total()
    dealer_card_total = get_card_total(true)
    player_stay = false
    dealer_stay = false
    player_bust = false
    dealer_bust = false
    
    while !player_stay || !dealer_stay
      # player
      if !player_stay
        player_stay = hit?()
        player_card_total = get_card_total()
        display_cards_and_total()
      
        if player_card_total > 21
          player_bust = true
          break
        end
      else
        display_cards_and_total()
      end
      
      # dealer
      if !dealer_stay
        dealer_stay = hit?(true)
        dealer_card_total = get_card_total(true)
        display_cards_and_total(true)

        if dealer_card_total > 21 
          dealer_bust = true
          break
        end
      else
        display_cards_and_total(true) 
      end
    end
    
    if player_bust
      puts "You busted with #{player_card_total}. You Lose!"
    elsif dealer_bust
      puts "Dealer busted with #{dealer_card_total}. You Win!"
    elsif player_card_total < dealer_card_total
      puts "Dealer's hand with #{dealer_card_total} beats your hand with #{player_card_total}. You Lose!"
    elsif player_card_total > dealer_card_total
      puts "Your hand with #{player_card_total} beats the dealer's hand with #{dealer_card_total}. You Win!"  
    elsif player_card_total == dealer_card_total
      puts "Both hands are #{player_card_total}. It's a Draw!"
    end
  end

end

# ----------------------- Procedural ------------------------------
=begin

def deal_card
  card = rand(1..13)
  
  case card
    when 1
      return "A"
    when 11
      return "J"
    when 12
      return "Q"
    when 13
      return "K"
    else
      return card
  end
end

def get_card_total(cards, limited=false)
  total = 0
  has_A = false;
  
  cards.each do |card|
    case card
      when "A"
        total += 1
        has_A = true
      when "K"
        total += 10
      when "Q"
        total += 10
      when "J"
        total += 10
      else
        total += card
    end
  end
  
  total += 10 if has_A == true && total + 10 <= 21
  return total
end

def display_cards_and_total(cards, is_dealer=false)
  card_total = get_card_total(cards)
  if is_dealer
    limited_total = get_card_total(cards, true)
    hand_display = cards[1..-1].unshift("?")
    hidden_card = cards.slice(0)

    case hidden_card
      when "A"
        hidden = 11
      when "K"
        hidden = 10
      when "Q"
        hidden = 10
      when "J"
        hidden = 10
      else
        hidden = hidden_card
    end

    hidden_card == "A" && limited_total + 10 > 21 ? limited_total = card_total - 1 : limited_total = card_total - hidden
 
    puts "Dealer's Hand:" 
    puts "Cards: #{hand_display}"
    #puts "Real Total: #{card_total}"
    puts "Current Total: #{card_displaytotal}\n\n"
  else
    puts "Player's Hand:"
    puts "Cards: #{cards}"
    puts "Total: #{card_total}\n\n"
  end
end

def get_user_input
  puts "Type 'h' to hit or 's' to stay"
  gets.chomp.strip
end

def initial_round
  player_card_1 = deal_card
  player_card_2 = deal_card
  
  dealer_card_1 = deal_card
  dealer_card_2 = deal_card
  return [player_card_1, player_card_2], [dealer_card_1, dealer_card_2]
end

def hit?(cards, is_dealer=false)
  
  # dealer
  if(is_dealer == true)
    cards_total = get_card_total(cards)
    dealer_stay = true

    if(cards_total < 17) # hit
      dealer_stay = false
      cards.push(deal_card)
    end
    
    return dealer_stay
  end
  
  # player
  input = get_user_input
  player_stay = true

  if(input == "s")
    return player_stay
  elsif(input == "h") 
    player_stay = false
    cards.push(deal_card)
    return player_stay
  else
    puts "Please enter a valid command"
    hit?(cards)
  end
end

def runner
  puts "Welcome to the Blackjack Table\n\n"
  player_cards, dealer_cards = initial_round
  display_cards_and_total(player_cards)
  display_cards_and_total(dealer_cards, true)

  player_card_total = get_card_total(player_cards)
  dealer_card_total = get_card_total(dealer_cards)
  player_stay = false
  dealer_stay = false
  player_bust = false
  dealer_bust = false
  
  while !player_stay || !dealer_stay
    # player
    if !player_stay
      player_stay = hit?(player_cards)
      player_card_total = get_card_total(player_cards)
      display_cards_and_total(player_cards)
    
      if player_card_total > 21
        player_bust = true
        break
      end
  else
    display_cards_and_total(player_cards)
  end
    

    # dealer
    if !dealer_stay
      dealer_stay = hit?(dealer_cards, true)
      dealer_card_total = get_card_total(dealer_cards)
      display_cards_and_total(dealer_cards, true)

      if dealer_card_total > 21 
        dealer_bust = true
        break
      end
  else
    display_cards_and_total(dealer_cards, true) 
  end
  end
  
  if player_bust
    puts "You busted with #{player_card_total}. You Lose!"
  elsif dealer_bust
    puts "Dealer busted with #{dealer_card_total}. You Win!"
  elsif player_card_total < dealer_card_total
    puts "Dealer's hand with #{dealer_card_total} beats your hand with #{player_card_total}. You Lose!"
  elsif player_card_total > dealer_card_total
    puts "Your hand with #{player_card_total} beats the dealer's hand with #{dealer_card_total}. You Win!"  
  elsif player_card_total == dealer_card_total
    puts "Both hands are #{player_card_total}. It's a Draw!"
  end
end

runner

=end