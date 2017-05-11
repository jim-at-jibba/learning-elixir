defmodule Identicon do
  # main function. progressively transform the string in here
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end  

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    # erlang graphical drawer
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    # does not return a new collections
    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end  

    :egd.render(image)
  end  

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # if passing a function to a Stnd library function we can remove the parens
    grid = Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid} 
  end

  # & declares that we are referencign a function
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex 
      |> Enum.chunk(3)
      |> Enum.map(&mirrow_row/1) 
      |> List.flatten
      |> Enum.with_index 

    %Identicon.Image{image | grid: grid}
  
  end

  def mirrow_row(row) do
    # [145, 34, 56]
    [first, second | _tail] = row

    # [145, 34, 56, 34, 145]
    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    # getting first three items from the list. RGB
    # use pattern matching. Because hex_list is an unassinged varibable. 
    # The value of image is assigned to hex_list
    #%Identicon.Image{hex: hex_list} = image
    ## [r, g, b] = hex_list - this does not work because for pattern matching to work the left and right must be the same
    # [r, g, b | _tail] = hex_list # This gives first three items of the list. Ignore the rest

    # The above can be shortened to - this has been moved to func declaration
    # %Identicon.Image{hex: [r, g, b | _tail]} = image

     # Updating the struct - we create a new struct.  
     %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Creates a has of a given input
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
