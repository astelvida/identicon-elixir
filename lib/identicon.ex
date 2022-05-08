defmodule Identicon do
  def main(input \\ "asdf") do
    hash_input(input)
    |> pick_color()

    # |> build_grid()
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list()
    %Identicon.Image{hex: hex}
  end

  @doc """
    first 3 list elements are our color
  """
  def pick_color(image) do
    IO.puts(inspect(image.hex))
    [r, g, b | _tail] = image.hex
    color = {r, g, b}
    %Identicon.Image{hex: color, grid: mirror_rows(Enum.chunk_every(Enum.take(image.hex, 15), 3))}
  end

  def mirror_rows(rows) do
    Enum.map(rows, fn row -> Enum.concat(row, Enum.slice(Enum.reverse(row), 1..3)) end)
  end

  def build_grid(hex) do
    hex
  end

  def grid_to_image(grid) do
    grid
  end

  def save_image(image) do
    image
  end
end

# identy = Identicon.main()
# [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]
# 912EC8
