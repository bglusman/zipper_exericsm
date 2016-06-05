defmodule BinTree do
  @moduledoc """
  A node in a binary tree.

  `value` is the value of a node.
  `left` is the left subtree (nil if no subtree).
  `right` is the right subtree (nil if no subtree).
  """
  @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  defstruct value: nil, left: nil, right: nil
end
require IEx

defmodule Zipper do
  alias BinTree, as: BT

  @type t :: %Zipper{ trail: any, tree: BinTree.t | nil }
  defstruct trail: nil, tree: nil

  @doc """
  Get a zipper focused on the root node.
  """
  # @type trail :: { :left, any, BinTree.t, trail }
  # | { :right, any, BinTree.t, trail }
  # | :top


  @spec from_tree(BT.t) :: Z.t
  def from_tree(tree), do:  %Zipper{tree: tree, trail: :top}

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(%{trail: _, tree: tree}) do
    tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(z) do
    case z do
      %{trail: :top, tree: tree} ->
        tree.value
      %{trail: {_,node,_,_}} ->
        node.value
    end
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left(%{trail: :top, tree: bt}) do
    case bt.left do
      nil ->
        nil
      new_node ->
        %{trail: {:left, new_node, bt, :top}, tree: bt}
    end
  end

  def left(%{trail: trail, tree: bt}) do
    {_, node, _, _} = trail
    case node.left do
      nil ->
        nil
      new_node ->
        %{trail: {:left, new_node, bt, trail}, tree: bt}
    end
  end

  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right(%{trail: :top, tree: bt}) do
    case bt.left do
      nil ->
        nil
      new_node ->
        %{trail: {:left, new_node, bt, :top}, tree: bt}
    end
  end

  def right(%{trail: trail, tree: bt}) do
    {_, node, _, _} = trail
    case node.right do
      nil ->
        nil
      new_node ->
        %{trail: {:right, new_node, bt, trail}, tree: bt}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up(%{trail: trail, tree: bt}) do
    case trail do
      :top ->
        nil
      {:left, node, bt, old_trail} ->
        %{trail: old_trail, tree: bt}
      {:right, node, bt, old_trail} ->
        %{trail: old_trail, tree: bt}
    end
  end

  defp replace(map, symbol, value) do
    Map.put(map, symbol, value)
  end

  defp recursive_change(new_node, node, :top, symbol, bt) do
    replace(bt, symbol, new_node)
  end


  defp recursive_change(new_node, node, {direction, parent_node, bt, old_trail}, symbol, bt) do
    replace(node, symbol, new_node)
    |> recursive_change(parent_node, old_trail, direction, bt)
  end

  defp recursive_change(new_node, node, error, symbol, bt), do: IO.inspect "error!!:#{error}"

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(z, v) do
    %{trail: {direction,node,bt,trail}, tree: bt} = z
    new_node = replace(node, :value, v)
    t_dir = trail_direction(z)
    new_bt = recursive_change(%{direction => new_node}, node, z[:trail], t_dir, bt)
    %{trail: {direction,node,new_bt,trail}, tree: new_bt}
  end

  def trail_direction(z) do
    z[:trail] |> elem(0)
  end

  @doc """
  Replace the left child tree of the focus node.
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(%Zipper{tree: tree} = zipper, leaf) do
    new_tree = %BinTree{tree | left: leaf}
    %Zipper{zipper | tree: new_tree}
  end

  @doc """
  Replace the right child tree of the focus node.
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(%Zipper{tree: tree} = zipper, leaf) do
    new_tree = %BinTree{tree | right: leaf}
    %Zipper{zipper | tree: new_tree}
  end

  # @type t :: %BinTree{ value: any, left: BinTree.t | nil, right: BinTree.t | nil }
  # defstruct value: nil, left: nil, right: nil

  # @type t :: %Zipper{ trail: any, tree: BinTree.t | nil }
  # defstruct trail: nil, tree: nil

end

defimpl Inspect, for: Zipper do
  import Inspect.Algebra


  def inspect(%{trail: t, tree: tree}, opts) do
    concat ["(Zipper:", to_doc(t, opts),
            ":", (if tree, do: to_doc(tree, opts), else: ""),
            ")"]
  end
end
