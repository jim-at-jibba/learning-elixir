defmodule CardsTest do
  use ExUnit.Case
  doctest Cards

  # 2 types of testing
  #   1. case test
  #   2. doc tests - doc tests are run when there are valid code examples in you docs
  # Test the things that you really care about

    test "create_deck makes 20 cards" do
      deck_length = length(Cards.create_deck)
      assert deck_length == 20 
    end

    test "shuffling a deck randomises it" do
      deck = Cards.create_deck
      # assert deck != Cards.shuffle(deck)
      refute deck == Cards.shuffle(deck)
    end
  end
