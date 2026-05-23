class_name ItemTool
extends Area3D

func can_put(_item: Item) -> bool:
	return false

func can_take(_item: Item) -> bool:
	return false

func put(_item: Item) -> bool:
	return false

func take() -> Item:
	return Item.new()
