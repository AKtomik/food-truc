class_name Microwave
extends ItemTool

var items_inside: Array[Item]

func can_put(_item: Item) -> bool:
	return true

func can_take(_item: Item) -> bool:
	return !items_inside.is_empty()

func put(item: Item) -> bool:
	item.reparent(self)
	item.global_position = self.global_position
	items_inside.append(item)
	return true

func take() -> Item:
	return items_inside.pop_front()