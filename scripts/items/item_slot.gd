class_name ItemSlot
extends Area3D

@export var child_item: Item = null

func full() -> bool:
	return child_item != null

func put_item(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	child_item = item
	return true
	
func take_item() -> Item:
	var item = child_item
	child_item = null
	return item
