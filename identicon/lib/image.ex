defmodule Identicon.Image do
    # We created the struc as a single location to 
    # holds all the data for the app

    # defines struct with a property called hex. This will store 
    # the list of bytes. With a default of nil
    defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end