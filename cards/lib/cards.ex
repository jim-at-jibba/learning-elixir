defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
  Returns a list of strings representing a deck of cards
  """
  def create_deck do
    # difining a list (array)
    # ["Ace", "two", "three"]
    values = ["Ace", "two", "three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"] 

    # list comprehension, iterating over collections
    # comprehensions are mapping functions
    # dont nest comprehensions. IT WONT WORK because of the implicite returns.
    # You will get a nested array of arrays

    # Solution #1
    # cards = for value <- values do
    #   for suit <- suits do
    #     "#{value} of #{suit}"
    #   end
    # end

    # List.flatten(cards)

    # Solution 2 - run multiple comprehensions at the same time!
   for suit <- suits, value <- values do
        "#{value} of #{suit}"
    end
    
  end

  # function with property
  def shuffle(deck) do
    # Elixir standard library enum - use with lists
    Enum.shuffle(deck)
  end

  @doc """
    Determines whether a deck contains a given card

  ## Example

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true
  """
  # method names with ? in them indicate that they will
  # return a boolean
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Divides a deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cards should be in 
    
  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
  """
  # returns a tuple
  # Cards.deal(deck, 5) {*hand*, *restOfDeck*}
  # Cards.deal(deck, 5) { hand: [], deck: []} js equivalent
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  # DONT USE IF STATEMENTS - USE CASE instead
  def load(filename) do
    # {status, binary} = File.read("my_deck") 

    # case status do
    #   :ok -> :erlang.binary_to_term(binary)
    #   :error -> "That file does not exist"
    # end

    # pattern matched case - the first match must match exactly. This is why
    # it works as a case
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist" # if we have a variable that is not used but is needed for pattern matching preceed with _
    end
  end

  def create_hand(hand_size) do
    # |> pipe operator allows you to chain method calls, 
    # the return value is automatically passed on to the next method
    # |> requires you to write methods what have consistent first arguments
    Cards.create_deck
    |> Cards.shuffle
    |> Cards.deal(hand_size)
  end
end