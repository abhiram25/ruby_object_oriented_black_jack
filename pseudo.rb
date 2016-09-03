# Participant

# states

# - hand = []
# - total = 0

# Verbs

# Setters/Getters
# 	- total
#   		- Add the values of the cards together

# - busted?
# - total > 21

# - hit
#   - Add a new card

# - stay
#   - evaluates to true

# Player < Participant



# Dealer < Participant

# Verbs

# - hit
#   - This method is invoked while total is less than 17

# - Stay

#    - This method is invoked when total is 17 or more

# Deck

# States

# - deck
#   - A nested array of 52 Card objects

# Verbs

#   deal
#   - Player and dealer get two cards from deck
#   - Player and dealer get a card when hit

# Card

# States

# - Shape
# - value
# - points

# Game

# states
# - deck
# - Participants

# methods

# start
# - Players are dealt cards
# - Player's cards are revealed
# - Player Turn
# - Dealer's cards are revlealed
# - Dealer Turn
# - Display Winner
# - Play Again

# # Access the instance variable @card

# # Player turn

# # Ask if Player wants to hit or stay
# # Break if player wants to stay
# # Add card to player's hand
# # Display cards and total
# # break if player busted

# Create total getter

# Create a data structure that associates the value with how much it's worth
# Should I put this in the Deck class or Card class

# Output the result

# If player busted?
# Print "Player busted. Player has"

# Name
# Location

# Why you chose Launch Schoool?

# Change aces to one in certain situations

# Add play again feature
# Rubocop refactoring

# When should an Ace be one

# All aces except one in the hand should be one unless
# the total becomes greater 21.

# Example

# Jake has Ace and 9
# Jake hits
# Jake gets Ace

# Only one Ace should be worth 1

# Before changing the value of an ace,
# we have to check if player would bust
# if an ace is worth 11

# Subtract 10 from total if you have at least one ace in your hand
# and the total is greater than 21

Create method where it detects if there is an ace