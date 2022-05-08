import Mogrify

# This does operations on an original image:
# Mogrify.open "input.jpg"
# |> Mogrify.resize("100x100") |> Mogrify.save

# # save/1 creates a copy of the file by default:
# image = open("input.jpg") |> resize("100x100") |> save
# # => %Image{path: "/tmp/260199-input.jpg", ext: ".jpg", ...}
# IO.inspect(image)

# # Resize to fill
# open("input.jpg") |> resize_to_fill("450x300") |> save

# # Resize to limit
# open("input.jpg") |> resize_to_limit("200x200") |> save

# # Extent
# open("input.jpg") |> extent("500x500") |> save

# # Gravity
# open("input.jpg") |> gravity("Center") |> save

defmodule Identicon do
  def main(input \\ "asdf") do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd()
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list()
    %Identicon.Image{hex: hex}
  end

  def pick_color(image) do
    [r, g, b | _tail] = image.hex
    %Identicon.Image{image | color: {r, g, b}}
  end

  def mirror_row(row) do
    row ++ tl(Enum.reverse(row))
  end

  def build_grid(image) do
    grid =
      image.hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def filter_odd(%Identicon.Image{grid: grid} = image) do
    filtered = Enum.filter(grid, fn {value, _index} -> rem(value, 2) == 0 end)
    %Identicon.Image{image | grid: filtered}
  end

  def grid_to_image(image) do
    # :egd.save(img, "image.png")
    # :egd.rectangle(img, 0, 250, :egd(green))
  end

  # def save_image(image) do
  #   image
  # end
end

# defprotocol Identy do
#   @doc "Calculates the size (and not the length!) of a data structure"
#   def size(data)
# end

identy = Identicon.main()

# identy = Identicon.main()

# def identy do
#   identy = Identicon.main()
# end

# [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]
# 912EC8
# https://excalidraw.com/#json=eagDj8eWJx4hhl5FMQ_D4,9R0DtBOCVU7ZUCpHFhOyOQ
