class_name Windo# named like that caus we Do orders (and also bcs Window is a godot class)
extends ItemTool

@export var orders_manager: OrdersManager

func can_put(_item: Item) -> bool:
	return orders_manager.has_order()

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	if (!orders_manager.has_order()): return false
	orders_manager.given_food(item)
	item.reparent(self)
	item.place_center()
	item.queue_free()
	return true

func take() -> Item:
	push_error("can't take anything in window")
	return Item.new()
