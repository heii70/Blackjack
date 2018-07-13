def welcome
  puts "Welcome to the Blackjack Table\n\n"
end

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

def get_card_total(cards)
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
  
  if(has_A == true && total + 10 <= 21)
    total += 10
  end
  return total
end

def display_cards_and_total(cards, is_dealer=false)
  card_total = get_card_total(cards)
  if is_dealer

  	hand_display = cards.slice(1, cards.length-1).unshift("?")

  	counter = 0
  	cards.each do |card|
  		counter += 1 if card == "A"
  	end

  	if cards.slice(0) == "A"
  		counter > 1 && card_total + 10 > 21 ? card_displaytotal = card_total - 1 :  card_displaytotal = card_total - 11
  	else
  		card_displaytotal = card_total - get_card_total([cards.slice(0)])
  	end
 
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
  # code #initial_round here
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
  welcome
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