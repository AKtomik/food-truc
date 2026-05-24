class_name Windo
extends ItemTool

@export var orders_manager: OrdersManager

func can_put(_item: Item) -> bool:
	return true

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	orders_manager.given_food(item)
	item.reparent(self)
	item.place_center()
	item.queue_free()
	return true

func take() -> Item:
	push_error("can't take anything in window")
	return Item.new()
