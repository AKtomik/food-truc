class_name ItemTool
extends Area3D

func can_put(_item: Item) -> bool:
	return true

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	item.reparent(self)
	item.global_position = self.global_position
	return true

func take() -> Item:
	return Item.new()
