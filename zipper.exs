defmodule BinTree do
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil
end

defmodule Zipper do
  alias BinTree, as: BT
  defstruct parent: nil, path: nil, tree: nil

  def from_tree(tree), do: %Zipper{tree: tree, parent: nil}

  def to_tree(%Zipper{tree: tree, parent: nil}), do: tree
  def to_tree(%Zipper{parent: parent}), do: to_tree(parent)

  def value(%Zipper{tree: tree}), do: tree.value

  def left(%{tree: %{left: nil}}), do: nil
  def left(%Zipper{tree: tree} = zipper) do
    %Zipper{tree: tree.left, path: :left, parent: zipper}
  end

  def right(%{tree: %{right: nil}}), do: nil
  def right(%Zipper{tree: tree} = zipper) do
    %Zipper{tree: tree.right, path: :right, parent: zipper}
  end

  def up(%Zipper{parent: parent}), do: parent

  def set_value(%Zipper{} = zipper, value), do: update(zipper, :value, value)
  def set_left(%Zipper{} = zipper, value), do: update(zipper, :left, value)
  def set_right(%Zipper{} = zipper, value), do: update(zipper, :right, value)

  defp update(%Zipper{tree: tree, parent: nil} = zipper, key, value) do
    new_tree = Map.put(tree, key, value)
    %Zipper{zipper | tree: new_tree}
  end
  defp update(%Zipper{tree: tree, path: path, parent: parent} = zipper, key, value) do
    new_tree = Map.put(tree, key, value)
    new_parent = update(parent, path, new_tree)
    %Zipper{zipper | tree: new_tree, parent: new_parent}
  end

end
