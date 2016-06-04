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

defmodule Zipper do
  @doc """
  Get a zipper focused on the root node.
  """
  # @type trail :: { :left, any, BinTree.t, trail }
  # | { :right, any, BinTree.t, trail }
  # | :top

  @spec from_tree(BT.t) :: Z.t
  def from_tree(bt) do
    # %{tree: bt}
    # |> &Map.merge(if Map.has_key?(bt, :left), do: %{left: bt.left}, else: %{})
    # |> &Map.merge(if Map.has_key?(bt, :right), do: %{right: bt.right}, else: %{})
    # |> &Map.merge(if Map.has_key?(bt, :value), do: %{value: bt.value}, else: %{})
    {:top, bt}
  end

  @doc """
  Get the complete tree from a zipper.
  """
  @spec to_tree(Z.t) :: BT.t
  def to_tree(z) do
    {_, tree} = z
    tree
  end

  @doc """
  Get the value of the focus node.
  """
  @spec value(Z.t) :: any
  def value(z) do
    case z do
      {:top, tree} ->
        tree.value
      {{_,node,_,_}, _} ->
        node.value
    end
  end

  def follow(trail) do
    #hmmm...
  end

  @doc """
  Get the left child of the focus node, if any.
  """
  @spec left(Z.t) :: Z.t | nil
  def left({:top, bt}) do
    case bt.left do
      nil ->
        nil
      new_node -> 
        {{:left, new_node, bt, :top}, bt}
    end
  end

  def left({trail, bt}) do
    {_, node, _, _} = trail
    case node.left do
      nil ->
        nil
      new_node -> 
        {{:left, new_node, bt, trail}, bt}
    end
  end
  
  @doc """
  Get the right child of the focus node, if any.
  """
  @spec right(Z.t) :: Z.t | nil
  def right({:top, bt}) do
    case bt.left do
      nil ->
        nil
      new_node -> 
        {{:left, new_node, bt, :top}, bt}
    end
  end

  def right({trail, bt}) do
    {_, node, _, _} = trail
    case node.right do
      nil ->
        nil
      new_node -> 
        {{:right, new_node, bt, trail}, bt}
    end
  end

  @doc """
  Get the parent of the focus node, if any.
  """
  @spec up(Z.t) :: Z.t
  def up({trail, bt}) do
    case trail do
      :top ->
        nil
      {:left, node, bt, old_trail} -> 
        {old_trail, bt}
      {:right, node, bt, old_trail} -> 
        {old_trail, bt}
    end
  end

  defp replace(map, symbol, value) do
    Map.merge(map, %{symbol => value})
  end

  defp recursive_change(new_node, node, :top, symbol, bt) do
    replace( bt, symbol, new_node)
  end

  defp recursive_change(new_node, node, {direction, parent_node, bt, old_trail}, symbol, bt) do
    replace(node, symbol, new_node)
    |> recursive_change(parent_node, old_trail, direction, bt)
  end

  @doc """
  Set the value of the focus node.
  """
  @spec set_value(Z.t, any) :: Z.t
  def set_value(z, v) do
    {direction, node, trail, bt} = z
    new_node = replace(node, :value, v)
    recursive_change(%{direction => new_node}, node, z, elem(trail, 0), bt)
  end
  
  @doc """
  Replace the left child tree of the focus node. 
  """
  @spec set_left(Z.t, BT.t) :: Z.t
  def set_left(z, l) do

  end
  
  @doc """
  Replace the right child tree of the focus node. 
  """
  @spec set_right(Z.t, BT.t) :: Z.t
  def set_right(z, r) do

  end
end
