class_name Trash
extends ItemTool

@export var item_resource: ItemResource
@export var price: int
@export var money_manager: CashMachine

func can_put(_item: Item) -> bool:
	return true

func can_take(_item: Item) -> bool:
	return false

func put(item: Item) -> bool:
	item.reparent(self)
	item.place_center()
	item.queue_free()
	return true

func take() -> Item:
	push_error("can't take anything in trash")
	return Item.new()
