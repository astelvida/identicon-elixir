defmodule Identicon do
  def main(input \\ "asdf") do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
    |> filter_odd()
    |> build_pixel_map()
    |> grid_to_image()
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list()
    %Identicon.Image{hex: hex, seed: input}
  end

  def pick_color(identicon) do
    [r, g, b | _tail] = identicon.hex
    %Identicon.Image{identicon | color: {r, g, b}}
  end

  def mirror_row(row) do
    row ++ tl(Enum.reverse(row))
  end

  def build_grid(identicon) do
    grid =
      identicon.hex
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{identicon | grid: grid}
  end

  def filter_odd(identicon) do
    grid = Enum.filter(identicon.grid, fn {code, _index} -> rem(code, 2) == 0 end)
    %Identicon.Image{identicon | grid: grid}
  end

  def build_pixel_map(identicon) do
    pixel_map =
      Enum.map(identicon.grid, fn {_value, index} ->
        {{rem(index, 5) * 50, div(index, 5) * 50},
         {(rem(index, 5) + 1) * 50, (div(index, 5) + 1) * 50}}
      end)

    %Identicon.Image{identicon | pixel_map: pixel_map}
  end

  def grid_to_image(identicon) do
    image = :egd.create(250, 250)
    fill = :egd.color(identicon.color)

    Enum.each(identicon.pixel_map, fn {p1, p2} ->
      :egd.filledRectangle(image, p1, p2, fill)
    end)

    :egd.save(:egd.render(image), "#{identicon.seed}.jpg")
    identicon
  end
end

# identy = Identicon.main()
